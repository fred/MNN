class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer   :user_id
      t.integer   :item_id
      t.string    :email
      t.timestamps
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :item_id
  end
end
