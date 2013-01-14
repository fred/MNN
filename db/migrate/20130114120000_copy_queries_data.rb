class CopyQueriesData < ActiveRecord::Migration
  def up
    say "Updating any existing queries.data to be HSTORE"
    Query.where("raw_data is not NULL and data is NULL").each do |t|
      t.data = t.raw_data
      t.raw_data = nil
      t.save
    end
  end

  def down
  end
end
