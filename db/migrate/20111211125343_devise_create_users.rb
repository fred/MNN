class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.confirmable
      t.token_authenticatable
      # t.encryptable
      
      # Custom Personal Fields
      t.text    :bio
      t.string  :name
      t.string  :address
      t.string  :twitter
      t.string  :diaspora
      t.string  :skype
      t.string  :gtalk
      t.string  :jabber
      t.string  :phone_number
      t.string  :time_zone
      
      # Karma Fields
      t.integer :ranking
      
      t.timestamps
    end
    add_index :users, :ranking
    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :unlock_token,         :unique => true
    add_index :users, :authentication_token, :unique => true
  end

end
