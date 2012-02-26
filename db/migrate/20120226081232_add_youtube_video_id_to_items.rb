class AddYoutubeVideoIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :youtube_id,  :string
    add_column :items, :youtube_vid, :boolean
    add_column :items, :youtube_img, :boolean
  end
end
