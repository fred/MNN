class AddTwitterHashtagsToItems < ActiveRecord::Migration
  def change
    add_column :items, :hashtags, :string
  end
end
