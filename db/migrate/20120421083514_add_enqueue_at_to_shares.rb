class AddEnqueueAtToShares < ActiveRecord::Migration
  def change
    add_column :shares, :enqueue_at, :timestamp
  end
end
