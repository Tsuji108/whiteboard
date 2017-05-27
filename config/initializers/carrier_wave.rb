require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# exif情報から画像向きを補正
module CarrierWave
  module MiniMagick
    def fix_exif_rotation
      manipulate! do |img|
        img.auto_orient
        img = yield(img) if block_given?
        img
      end
    end
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY'],
      :region                => ENV['S3_REGION']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end