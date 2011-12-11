class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string   :title
      t.text     :description
      t.timestamps
    end
    create_table :roles_users, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
    end
  end
end
