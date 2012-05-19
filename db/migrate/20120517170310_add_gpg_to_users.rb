class AddGpgToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :gpg, :string
  end
end
