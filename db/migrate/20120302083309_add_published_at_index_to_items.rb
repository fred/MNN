class AddPublishedAtIndexToItems < ActiveRecord::Migration
  def change
    add_index(:items, :published_at, :order => {:published_at => :desc})
  end
end
