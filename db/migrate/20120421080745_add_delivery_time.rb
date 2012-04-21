class AddDeliveryTime < ActiveRecord::Migration
  def change
    add_column :email_deliveries, :send_at, :timestamp
  end
end
