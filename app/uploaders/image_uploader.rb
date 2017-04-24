class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :file

  # S3のディレクトリ名
  def store_dir
    "sample-image/#{model.id}"
  end

  # デフォルト画像は1200x5000に収まるようリサイズ
  process resize_to_limit: [1200, 5000]

  # サムネイル画像
  version :thumb do
    process resize_to_fill: [100, 100]
  end

  # 許可する画像の拡張子
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # 保存するファイルの命名規則
  def filename
     "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  # 一意となるトークンを作成
  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end
end