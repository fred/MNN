class AddQueriesDataIndexes < ActiveRecord::Migration

  def up
    add_index :queries, :data, concurrently: true, using: 'gist'
  end

  def down
    remove_index :queries, :data
  end
end
