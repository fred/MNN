class RemoveRailsAdminHistories < ActiveRecord::Migration
  def up
    drop_table :rails_admin_histories
  end

  def down
  end
end
