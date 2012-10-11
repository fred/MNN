ActiveAdmin.register FeedSite do
  config.sort_order = 'title_asc'
  config.per_page = 12
  menu parent: "News", priority: 23, label: "Feed Sites", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, FeedSite)
  }

  collection_action :refresh, method: :get do
    FeedJob.create(enqueue_at: Time.now+30)
    flash[:notice] = "Feeds will be refreshed in 30 seconds..."
    redirect_to(session[:return_to] || admin_feed_sites_path)
  end

  action_item do
    link_to('Refresh', refresh_admin_feed_sites_path)
  end

  # Filters
  filter :category
  filter :user
  filter :title
  filter :description
  filter :site_url

  index do
    column :image do |feed_site|
      link_to image_tag(feed_site.image.url(:medium)), admin_feed_site_path(feed_site) if feed_site.image.present?
    end
    column :title do |feed_site|
      link_to feed_site.title, admin_feed_site_path(feed_site)
    end
    column "Order", :sort_order
    column :category, sortable: :category_id
    column :site_url do |feed_site|
      if feed_site.site_url
        link_to("Site URL", feed_site.site_url)
      end
    end
    column "Feed URL", :url do |feed_site|
      link_to "Feed URL", feed_site.url
    end
    column :last_modified
    column :updated_at
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
      :last_modified,
      :updated_at,
      :created_at
    render "show"
  end
  # Form
  form partial: "form"
end
