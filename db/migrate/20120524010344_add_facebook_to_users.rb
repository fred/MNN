class AddFacebookToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook,     :string
    add_column :users, :fbuid,        :string
    add_column :users, :oauth_token,  :string
    add_column :users, :oauth_data,   :text
    add_column :users, :show_public,  :boolean, default: false
  end
end
