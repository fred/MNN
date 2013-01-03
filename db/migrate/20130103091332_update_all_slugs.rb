class UpdateAllSlugs < ActiveRecord::Migration
  def up
    Item.where("slug !~* '^[0-9]{3,}-$'").each do |item|
      item.set_custom_slug
    end
  end

  def down
  end
end
