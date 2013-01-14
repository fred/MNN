class CreateHstoreMigration < ActiveRecord::Migration
  def self.up
    create_extension "hstore"
  end

  def self.down
    drop_extension "hstore"
  end
end