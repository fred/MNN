ActiveAdmin::Dashboards.build do
  section "Articles" do
    render 'drafts'
    render 'history'
  end
  section "Comments" do
    render 'comments_stats'
  end
  section "Users" do
    render 'user_stats'
  end
end

module ActiveAdmin
  module Views
    class Footer < Component
      def build
        super id: "footer"
        para "Worldmathaba Admin -- #{Time.now.to_s(:long)}"
      end
    end
  end
end
