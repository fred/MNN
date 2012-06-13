class AddContentTypeToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :content_type, :string
  end
end
