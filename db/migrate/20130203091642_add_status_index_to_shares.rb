class AddStatusIndexToShares < ActiveRecord::Migration
  def up
    add_index    :shares, :processed
    add_index    :shares, :item_id
    remove_index :shares, [:item_id, :processed]
  end
  def down
    remove_index :shares, :processed
    remove_index :shares, :item_id
    add_index    :shares, [:item_id, :processed]
  end
end
