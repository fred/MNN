class AddOauthIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:oauth_uid, :provider]
    add_index :users, :items_count
  end
end
