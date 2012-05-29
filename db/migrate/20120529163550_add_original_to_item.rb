class AddOriginalToItem < ActiveRecord::Migration
  def change
    add_column :items, :original, :boolean
    remove_column :items, :member_only
    remove_column :items, :formatting_type
    remove_column :items, :protected_record
  end
end
