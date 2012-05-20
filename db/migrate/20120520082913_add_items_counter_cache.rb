class AddItemsCounterCache < ActiveRecord::Migration
  def change
  	add_column :users, :items_count, :integer
  end
end
