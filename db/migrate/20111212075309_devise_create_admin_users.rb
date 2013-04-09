class DeviseCreateAdminUsers < ActiveRecord::Migration
  def migrate(direction)
    super
    # Create a default user
    AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password') if direction == :up
  end

  def change
    add_column :users, :type, :string
    add_index :users, :type
  end
end