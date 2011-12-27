class RegenerateSlugs < ActiveRecord::Migration
  def change
    Category.all.each {|t| t.save}
    Tag.all.each {|t| t.save}
  end
end
