ActiveAdmin.register FeedEntry do
  config.sort_order = 'id_desc'
  config.per_page = 50
  menu parent: "Items", priority: 24, label: "Feed Items"

  action_item do
    link_to('Import', new_admin_item_path(feed_id: feed_entry.id))
  end

  index do
    column :feed_site
    column :title do |feed_entry|
      link_to feed_entry.title, admin_feed_entry_path(feed_entry)
    end
    column :url do |feed_entry|
      if feed_entry.url.present?
        link_to("URL", feed_entry.url, target: feed_entry.url, title: feed_entry.url)
      end
    end
    column :summary
    column :author
    column :published
    default_actions
  end
  # Show page
  show title: :title do
    attributes_table do
      row :feed_site
      row :title
      row :url do |t|
        link_to(t.url.truncate(90),t.url)
      end
      row :author
      row :published
      row :summary
      row :content do |t|
        div(simple_format(t.content))
      end
    end
    render "show"
  end
end
