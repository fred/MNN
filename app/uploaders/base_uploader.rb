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

  # partitions ID to be like: 0000/0000/0123
  # to keep no more than 10,000 entries per directory
  # EXT3 max: 32,000 dirs
  # EXT4 max: 64,000 dirs
  def partition(modelid)
    ("%012d" % modelid).scan(/\d{4}/).join("/")
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end