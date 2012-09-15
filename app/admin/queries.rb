ActiveAdmin.register Query do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.sort_order = "created_at_desc"
  menu parent: "Items", label: 'Site Searches', priority: 10, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Query)
  }
  actions :index
  config.comments = false
  index title: "Searches" do
    column "Search Term", sortable: :keyword do |t|
      link_to t.keyword.to_s.truncate(50), search_path(q: t.keyword.to_s), target: "_blank"
    end
    column "IP", sortable: false do |t|
      link_to(t.raw_data[:ip], "http://www.geoiptool.com/en/?IP=#{t.raw_data[:ip]}", target: "_blank") if t.raw_data[:ip].present?
    end
    column "From", sortable: false do |t|
      link_to("URL", t.raw_data[:referrer], title: t.raw_data[:referrer], taget: "_blank") if t.raw_data[:referrer].present?
    end
    column "UserAgent", sortable: false do |t|
      t.short_user_agent
    end
    column "Lang", :locale
    column "User", sortable: :user_id do |t|
      link_to t.user.public_display_name, admin_user_path(t.user) if t.user
    end
    column "Date", sortable: :created_at do |t|
      t.created_at.to_s(:long) if t.created_at
    end
  end
  controller do
    def scoped_collection
      Query.includes(:item, :user)
    end
  end
end
