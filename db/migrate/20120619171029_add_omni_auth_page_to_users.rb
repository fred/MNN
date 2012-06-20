class AddOmniAuthPageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_page, :string
  end
end
