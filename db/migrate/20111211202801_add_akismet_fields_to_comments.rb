class AddAkismetFieldsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_ip,     :string
    add_column :comments, :user_agent,  :string
    add_column :comments, :approved_by, :integer
    add_column :comments, :approved,    :boolean, :default => false
    add_column :comments, :suspicious,  :boolean, :default => false
    add_column :comments, :marked_spam, :boolean, :default => false
    
    add_index :comments, :approved_by
    add_index :comments, :approved
    add_index :comments, :suspicious
    add_index :comments, :marked_spam
  end
end
