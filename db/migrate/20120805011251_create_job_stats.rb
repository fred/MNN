class CreateJobStats < ActiveRecord::Migration
  def change
    create_table :job_stats do |t|
      t.string    :processable_type
      t.integer   :processable_id
      t.integer   :job_name
      t.integer   :job_id
      t.boolean   :processed, default: false
      t.datetime  :enqueue_at
      t.timestamps
    end
    add_index :job_stats, [:processable_id, :processable_type]
    add_index :job_stats, :job_name
    add_index :job_stats, :job_id
  end
end
