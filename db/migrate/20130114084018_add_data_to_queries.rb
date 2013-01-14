class AddDataToQueries < ActiveRecord::Migration
  def change
    add_column :queries, :data, :hstore
  end
end
