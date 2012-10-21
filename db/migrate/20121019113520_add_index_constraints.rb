class AddIndexConstraints < ActiveRecord::Migration
  def change
    add_index :categories,  :title, unique: true
    add_index :tags,        :title, unique: true
    add_index :roles,       :title, unique: true


    execute "ALTER TABLE items ALTER COLUMN title SET NOT NULL"
    execute "ALTER TABLE items ALTER COLUMN published_at SET NOT NULL"
  end
end
