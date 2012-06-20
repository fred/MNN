class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string    :title
      t.string    :url
      t.integer   :priority, default: 100
      t.text      :description
      t.timestamps
    end
  end
end
