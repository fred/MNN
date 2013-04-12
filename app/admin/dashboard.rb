ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: "Dashboard"

  action_item if: proc { authorized?(:create, Item) } do
    link_to "New Item", new_admin_item_path
  end
  action_item do
    link_to "Website", "/"
  end

  content title: "Admin Dashboard" do

    if authorized?(:read, Item)
      panel "Draft Articles" do
        render 'drafts'
      end
    end

    if authorized?(:read, Version)
      panel "Database History" do
        render 'history'
      end
    end

    if authorized?(:read, Comment)
      panel "Latest Comments (updated every 5 minutes)" do
        render 'comments_stats'
      end
      panel "Pending Comments (updated every 5 minutes)" do
        render 'pending_comments'
      end
    end

    if current_ability.can?(:read, User)
      panel "Recently Logged in Users (updated every 5 minutes)" do
        render 'logged_users'
      end
      panel "Recently Registered Users (updated every 5 minutes)" do
        render 'registered_users'
      end
    end

  end
end
