class RegenerateSlugs < ActiveRecord::Migration
  def change
    Category.reset_column_information
    Tag.reset_column_information
    Category.all.each {|t| t.save}
    Tag.all.each {|t| t.save}
  end
end
