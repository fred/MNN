ActiveAdmin.register FeedSite do
  config.sort_order = 'id_asc'
  index do
    column :id
    column :avatar do |feed_site|
      link_to image_tag(feed_site.avatar.url(:medium)), admin_feed_site_path(feed_site)
    end
    column "Order", :sort_order
    column :title do |feed_site|
      link_to feed_site.title, admin_feed_site_path(feed_site)
    end
    column :category, :sortable => :category_id
    column :site_url do |feed_site|
      if feed_site.site_url
        link_to("Site URL", feed_site.site_url)
      end
    end
    column "Feed URL", :url do |feed_site|
      link_to "Feed URL", feed_site.url
    end
    column :etag

    column :featured
    column :updated_at
    column :created_at
    default_actions
  end
  
  # Show page
  show do
    attributes_table :id,
      :title,
      :sort_order,
      :url,
      :etag,
      :category,
      :site_url,
      :featured,
      :updated_at,
      :created_at
    render "show"
  end
  # Form
  form :partial => "form"
end
