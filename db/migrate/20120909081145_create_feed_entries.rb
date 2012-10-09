class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string   :title
      t.string   :url
      t.string   :author
      t.string   :image
      t.text     :summary
      t.text     :content
      t.datetime :published
      t.integer  :feed_site_id
      t.timestamps
    end
    add_index :feed_entries, :feed_site_id
  end
end
