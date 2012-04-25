class AddTypeToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :type, :string
  	add_index  :subscriptions, [:type]
  end
end
