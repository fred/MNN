class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :locale
      t.string :description
      t.timestamps
    end
    add_column :items, :language_id, :integer
    add_index :items, :language_id
  end
end
