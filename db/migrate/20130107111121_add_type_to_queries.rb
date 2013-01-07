class AddTypeToQueries < ActiveRecord::Migration
  def change
    add_column :queries, :type, :string
    add_index  :queries, :type
  end
end
