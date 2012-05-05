# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes
  
  # Set quality to 90 (default: 85)
  process quality: 90
  
  # Set Watermark
  # process watermark: "#{Rails.root}/public/watermark.png"

  # Choose what kind of storage to use for this uploader:
  # storage :file
  if Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  # Add mime-type to images
  process :set_content_type

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process scale: [50, 50]
  # end
  version :mini do
    process resize_to_fit: [30, 30]
  end
  version :thumb do
    process resize_to_fit: [50, 50]
  end
  version :small do
    process resize_to_fit: [80, 80]
  end
  version :medium do
    process resize_to_fit: [160, 160]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end
  def extension_white_list
    %w(jpg jpeg gif png tiff)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  
  def filename
     @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
