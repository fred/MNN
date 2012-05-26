class AddCommentsCountToItems < ActiveRecord::Migration
  def change
    add_column :items, :comments_count, :integer, default: 0
  end
end
