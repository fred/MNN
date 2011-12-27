class AddSlugToCategories < ActiveRecord::Migration
  def change
    # Slug for Category
    add_column  :categories,  :slug, :string
    add_index   :categories,  :slug, :unique => true
    # Slug for Tag
    add_column  :tags,        :slug, :string
    add_index   :tags,        :slug, :unique => true
  end
end