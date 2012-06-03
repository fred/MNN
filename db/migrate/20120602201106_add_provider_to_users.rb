class AddProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :oauth_uid, :string
    User.reset_column_information
    User.where("fbuid is not NULL").map {|t| t.update_attribute(:provider, 'facebook')}
    User.where("fbuid is not NULL").map {|t| t.update_attribute(:oauth_uid, t.fbuid)}
    remove_column :users, :fbuid
  end
end
