class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :title
      t.string  :link_title
      t.string  :slug
      t.integer :priority
      t.integer :language_id
      t.integer :user_id
      t.boolean :active
      t.text    :body
      t.timestamps
    end
  end
end
