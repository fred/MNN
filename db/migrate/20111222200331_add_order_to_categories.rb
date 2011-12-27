class AddOrderToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :priority, :integer, :default => 10
    add_column :categories, :active, :boolean, :default => true
  end
end
