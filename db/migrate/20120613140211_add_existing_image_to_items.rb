class AddExistingImageToItems < ActiveRecord::Migration
  def change
    add_column :attachments, :parent_id, :integer
  end
end
