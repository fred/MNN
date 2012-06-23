# encoding: utf-8
class GpgUploader < BaseUploader

  def store_dir
    "uploads/users/#{mounted_as}/#{model.id}"
  end
    
  def extension_white_list
    %w(asc key gpg txt)
  end

end
