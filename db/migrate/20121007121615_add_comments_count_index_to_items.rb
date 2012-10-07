class AddCommentsCountIndexToItems < ActiveRecord::Migration
  def change
    add_index :items, :original
    add_index :items, :comments_count
  end
end
