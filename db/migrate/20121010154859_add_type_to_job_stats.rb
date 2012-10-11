class AddTypeToJobStats < ActiveRecord::Migration
  def change
    remove_column :job_stats, :job_name
    add_column :job_stats, :type, :string
    add_index  :job_stats, :type
    execute "truncate table job_stats"
  end
end
