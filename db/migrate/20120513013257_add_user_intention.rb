class AddUserIntention < ActiveRecord::Migration
  def change
  	add_column :users, :registration_role, :string
  end
end
