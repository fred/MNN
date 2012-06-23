class ItemsCountDefaultValue < ActiveRecord::Migration
  def up
    change_column :users, :items_count, :integer, default: 0
    User.reset_column_information
    User.where(items_count: nil).update_all(items_count: 0)
  end

  def down
    change_column :users, :items_count, :integer, default: nil
  end
end
