ActiveAdmin.register_page "Drafts" do
  menu priority: 2, label: "Drafts", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content do
    render "drafts"
  end
end

ActiveAdmin.register_page "Recent Page Views" do
  menu priority: 2, label: "Recent Page Views", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content do
    render "page_views"
  end
end

ActiveAdmin.register_page "Database History" do
  menu priority: 2, label: "Database History", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content do
    render "history"
  end
end

ActiveAdmin.register_page "User Stats" do
  menu priority: 9, label: "User Stats", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content do
    render "user_stats"
  end
end

ActiveAdmin.register_page "Popular Searches" do
  menu priority: 2, label: "Popular Searches", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content do
    render "popular_searches"
  end
end

ActiveAdmin.register_page "DB Stats" do
  menu priority: 2, label: "DB Stats", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content do
    render "db_stats"
  end
end

ActiveAdmin.register_page "Charts" do
  menu priority: 2, label: "Charts", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content do
    render "charts"
  end
end
