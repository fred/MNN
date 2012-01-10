class AddSlugToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :slug, :string
    add_index :languages, :slug, :unique => true
  end
end
