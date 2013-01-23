class DeleteUnusedColumns < ActiveRecord::Migration
  def up
    remove_column :items, :allow_star_rating
  end
  def down
    add_column :items, :allow_star_rating, :boolean, default: true
  end
end
