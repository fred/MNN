class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.integer :scorable_type
      t.integer :scorable_id
      t.integer :points
      t.timestamps
    end
    add_index :scores, :user_id
    add_index :scores, [:scorable_id, :scorable_type]
  end
end
