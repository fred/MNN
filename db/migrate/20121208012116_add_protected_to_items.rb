class AddProtectedToItems < ActiveRecord::Migration
  def change
    add_column :items, :protected, :boolean, default: false
  end
end
