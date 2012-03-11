class AddStickyToItems < ActiveRecord::Migration
  def change
    add_column  :items, :sticky, :boolean, :default => false
    add_index   :items, :sticky
  end
end
