class AddWidthToYoutubeVideo < ActiveRecord::Migration
  def change
    add_column :items, :youtube_res, :string
  end
end
