class RenameFileToImageOnAttachments < ActiveRecord::Migration
  def change
    rename_column :attachments, :file, :image
  end
end
