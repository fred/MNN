class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer   :item_id
      t.boolean   :processed, :default => false
      t.string    :type
      t.string    :status
      t.datetime  :processed_at
      t.timestamps
    end
  end
end