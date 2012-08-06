# encoding: utf-8
require 'carrierwave/processing/mime_types'
class BaseUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes

  if Rails.env.test?
    storage :file
  else
    storage :fog
  end
  
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def filename
    @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end