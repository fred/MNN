class UpdateQueriesType < ActiveRecord::Migration
  def up
    say "Updating any existing page views and Searches type column for STI"
    execute "UPDATE queries SET type='PageView' where item_id is not NULL"
    execute "UPDATE queries SET type='SearchQuery' where item_id is NULL"
  end

  def down
  end
end
