class AddItemPublished < ActiveRecord::Migration
  def change
    add_column :items, :author_status, :string
  end
end