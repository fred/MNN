class AddAdminToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :admin, :boolean, default: false
    add_index  :subscriptions, :admin
  end
end
