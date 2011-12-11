class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings, :id => false, :force => true do |t|
      t.integer :tag_id
      t.integer :taggable_id
    end

    add_index :taggings, [:tag_id]
    add_index :taggings, [:taggable_id, :tag_id]
  end
end