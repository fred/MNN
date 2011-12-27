class AddSlugToCategories < ActiveRecord::Migration
  def change
    # Slug for Category
    add_column  :categories,  :slug, :string
    add_index   :categories,  :slug, :unique => true
    # Slug for Tag
    add_column  :tags,        :slug, :string
    add_index   :tags,        :slug, :unique => true
    
    Category.reset_column_information
    Tag.reset_column_information
    Category.all.each {|t| t.save}
    Tag.all.each {|t| t.save}
  end
end