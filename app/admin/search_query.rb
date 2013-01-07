ActiveAdmin.register SearchQuery do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.sort_order = "id_desc"
  menu parent: "Items", label: 'Site Searches', priority: 10, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, SearchQuery)
  }
  actions :index, :show
  config.comments = false
  index title: "Searches" do
    column "Search Term", sortable: :keyword do |t|
      link_to t.keyword.to_s.truncate(50), search_path(q: t.keyword.to_s), target: "_blank"
    end
    column "IP", sortable: false do |t|
      link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", target: "_blank") if t.user_ip.present?
    end
    column "Referrer", sortable: false do |t|
      link_to("URL", t.referrer, title: t.referrer, taget: "_blank") if t.referrer.present?
    end
    column "UserAgent", sortable: false do |t|
      t.short_user_agent
    end
    column "Lang", :locale
    column "User", sortable: :user_id do |t|
      link_to t.user.public_display_name, admin_user_path(t.user) if t.user
    end
    column "Time", sortable: :created_at do |t|
      t.created_at.to_s(:short) if t.created_at
    end
    default_actions
  end
  controller do
    def scoped_collection
      SearchQuery.includes(:user)
    end
  end
end
