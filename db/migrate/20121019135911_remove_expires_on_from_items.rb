class RemoveExpiresOnFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :expires_on
  end

  def down
    add_column :items, :expires_on, :datetime
  end
end
