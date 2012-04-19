class CreateEmailDeliveries < ActiveRecord::Migration
  def change
    create_table :email_deliveries do |t|
      t.integer   :item_id
      t.integer   :user_id
      t.timestamps
    end
    add_index :email_deliveries, :user_id
    add_index :email_deliveries, :item_id
  end
end
