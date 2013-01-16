class AddStatusToDeliveries < ActiveRecord::Migration
  def change
    add_column :email_deliveries, :delivered, :boolean, default: false
  end
end
