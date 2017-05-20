class ProfImgUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  process resize_to_limit: [100, 100]

  if Rails.env.production?
    storage :fog
    def store_dir
      "#{model.id}"
    end
  else
    storage :file
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
