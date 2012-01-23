class AddPageAndShareIndexes < ActiveRecord::Migration
  def change
    add_index :pages, :slug, :unique => true
    add_index :pages, :language_id
    add_index :pages, :active
    add_index :languages, :locale
    add_index :shares, :type
    add_index :shares, [:item_id, :processed]
  end
end
