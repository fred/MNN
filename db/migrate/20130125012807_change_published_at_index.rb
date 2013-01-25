class ChangePublishedAtIndex < ActiveRecord::Migration
  def up
    execute("DROP INDEX index_items_on_published_at;")
    execute("CREATE INDEX index_items_on_published_at ON items(published_at DESC NULLS LAST);")
    remove_index :items, [:category_id, :draft, :published_at]
  end

  def down
    add_index :items, [:category_id, :draft, :published_at]
  end
end
