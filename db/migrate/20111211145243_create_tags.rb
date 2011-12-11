class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.string :type
      t.timestamps
    end
    add_index :tags, :type
  end
end
