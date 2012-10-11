ActiveAdmin.register_page "News" do
  action_item do
    link_to('Refresh', refresh_admin_feed_sites_path)
  end
  content do
    render "feeds"
  end
end