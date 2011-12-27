class AddMetaTagsToImages < ActiveRecord::Migration
  def change
    add_column :attachments, :title, :string
    add_column :attachments, :alt_text, :string
    add_column :items, :deleted_at, :datetime
  end
end
