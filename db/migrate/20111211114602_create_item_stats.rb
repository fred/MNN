class CreateItemStats < ActiveRecord::Migration
  def change
    create_table :item_stats do |t|
      # Light table to hold page views counter
      t.integer :item_id
      t.integer :views_counter
    end
  end
end
