# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes

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
    "uploads/documents/#{mounted_as}/#{model.id}"
  end
  
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  def extension_white_list
    %w(txt pdf doc docx ppt pptx zip bz2 gz tar tgz 
       fodg fodp fods fodt odb odi odm oos oot otf otg 
       oth oti otp ots ott sda sdc sdd sdp sds sdv sdw 
       sfs smf sms std sti stw sxd sxg sxm vor odf odg 
       ods odt rtf sxc sxw odp otc sdb sdw sgl smd stc 
       sxd uot xls xlsx)
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
