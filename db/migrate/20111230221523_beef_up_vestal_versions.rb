class BeefUpVestalVersions < ActiveRecord::Migration
  def up
    add_column :versions, :ip, :string
    add_column :versions, :tag, :string
    add_column :versions, :user_email, :string
    add_column :versions, :user_agent, :string
  end
  def down
    remove_column :versions, :ip
    remove_column :versions, :tag
    remove_column :versions, :user_agent
    remove_column :versions, :user_email
  end
end
