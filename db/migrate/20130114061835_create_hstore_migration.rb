class CreateHstoreMigration < ActiveRecord::Migration
  def self.up
    # create_extension "hstore"
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
  end

  def self.down
    # drop_extension "hstore"
    execute "DROP EXTENSION IF EXISTS hstore"
  end
end
