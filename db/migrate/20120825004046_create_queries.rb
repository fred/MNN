class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string    :keyword
      t.string    :referrer
      t.string    :locale
      t.integer   :item_id
      t.integer   :user_id
      t.text      :raw_data
      t.timestamps
    end
    add_index :queries, :item_id
    add_index :queries, :locale
  end
end
