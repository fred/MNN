class AddIndexToItemStats < ActiveRecord::Migration
  def change
    add_index :item_stats, :item_id
  end
end
