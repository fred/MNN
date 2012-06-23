# encoding: utf-8
class DocumentUploader < BaseUploader

  def store_dir
    "uploads/documents/#{mounted_as}/#{model.id}"
  end
  
  def extension_white_list
    %w(txt pdf doc docx ppt pptx zip bz2 gz tar tgz 
       fodg fodp fods fodt odb odi odm oos oot otf otg 
       oth oti otp ots ott sda sdc sdd sdp sds sdv sdw 
       sfs smf sms std sti stw sxd sxg sxm vor odf odg 
       ods odt rtf sxc sxw odp otc sdb sdw sgl smd stc 
       sxd uot xls xlsx)
  end

end
