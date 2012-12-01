class AddDefaultTimeZone < ActiveRecord::Migration
  def up
    change_column_default(:users, :time_zone, "UTC")
  end

  def down
    change_column_default(:users, :time_zone, nil)
  end
end
