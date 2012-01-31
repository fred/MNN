class AddTimestampsToItemStats < ActiveRecord::Migration
  def change
    add_column :item_stats, :updated_at, :datetime
    add_column :item_stats, :created_at, :datetime
  end
end
