class AddAttachableTypeToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :attachable_type, :string
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
