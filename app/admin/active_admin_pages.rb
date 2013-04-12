ActiveAdmin.register_page "Drafts" do
  menu priority: 2, label: "Drafts", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content title: "Draft Articles" do
    if authorized?(:read, Item)
      panel "Draft Articles" do
        render 'drafts'
      end
    end
  end
end

ActiveAdmin.register_page "RecentPageViews" do
  menu priority: 2, label: "Recent Page Views", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content title: "Recent Page Views" do
    if authorized?(:read, PageView)
      panel "Recent Page Views (updated every 5 minutes)" do
        render "page_views"
      end
    end
  end
end

ActiveAdmin.register_page "DatabaseHistory" do
  menu priority: 2, label: "Database History", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content title: "Database History" do
    if authorized?(:read, Version)
      panel "Database History" do
        render 'history'
      end
    end
  end
end

ActiveAdmin.register_page "UserStats" do
  menu priority: 9, label: "User Stats", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content title: "User Stats" do
    if authorized?(:read, User)
      panel "Recently Logged in Users (updated every 5 minutes)" do
        render 'logged_users'
      end
      panel "Recently Registered Users (updated every 5 minutes)" do
        render 'registered_users'
      end
    end
  end
end

ActiveAdmin.register_page "PopularSearches" do
  menu priority: 2, label: "Popular Searches", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content title: "Popular Searches" do
    if authorized?(:read, SearchQuery)
      panel "Popular Searches (updated every 10 minutes)" do
        render 'popular_searches'
      end
    end
  end
end

ActiveAdmin.register_page "DbStats" do
  menu priority: 2, label: "DB Stats", parent: "Dashboard"
  action_item do
    link_to "Website", "/"
  end
  content title: "Database Statistics" do
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
