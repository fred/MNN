class AddItemCategoryDraftIndex < ActiveRecord::Migration
  def change
    add_index :items, [:category_id, :draft, :published_at]
  end
end
