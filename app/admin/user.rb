# USER
ActiveAdmin.register User do
  config.clear_sidebar_sections!
  before_filter only: :index do
    @per_page = 12
  end
  controller.authorize_resource
  config.comments = false
  # config.sort_order = "last_sign_in_at_desc"
  menu parent: "Members", priority: 24, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, User)
  }
  form partial: "form"

  show title: :title do
    attributes_table do
      row :id
      row :email
      row :name
      row :registration_role
      row :time_zone
      row :provider
      row 'Facebook Page', &:facebook
      row :twitter
      row :diaspora
      row :jabber
      row :phone_number
      row :avatar do |user|
        image_tag(user.main_image(:thumb))
      end
      row :bio
      bool_row :show_public
      row "Logged in at", &:last_sign_in_at
      row "Last Seen", &:current_sign_in_at
      row "Last IP" do |user|
        if user.last_sign_in_ip
          link_to user.last_sign_in_ip.to_s, 
            "http://www.geoiptool.com/en/?IP=#{user.last_sign_in_ip.to_s}"
        end
      end
      row "Current IP" do |user|
        if user.current_sign_in_ip
          link_to user.current_sign_in_ip.to_s,
            "http://www.geoiptool.com/en/?IP=#{user.current_sign_in_ip.to_s}"
        end
      end
      row :created_at
      row :updated_at
    end
  end

  index title: "Users" do
    id_column
    column "Avatar", sortable: false do |user|
      image_tag user.main_image(:thumb), class: 'user-avatar-mini'
    end
    column :name
    column :email
    column :time_zone
    column :provider
    column "Facebook", sortable: false do |user|
      if user.facebook.present?
        link_to "Facebook", user.facebook
      end
    end
    column "Twitter", sortable: false do |user|
      if user.twitter.present?
        twitter_user_link(user.twitter)
      end
    end
    column :role_titles
    column :type
    column "Subscribed", sortable: false do |user|
      bool_symbol user.has_subscription?
    end
    column "Logins", :sign_in_count
    column "Logged in", :last_sign_in_at
    column "Last Seen", :current_sign_in_at
    column "Last IP" do |user|
      if user.last_sign_in_ip
        link_to user.last_sign_in_ip.to_s,
          "http://www.geoiptool.com/en/?IP=#{user.last_sign_in_ip.to_s}"
      end
    end
    column "Current IP" do |user|
      if user.current_sign_in_ip
        link_to user.current_sign_in_ip.to_s,
          "http://www.geoiptool.com/en/?IP=#{user.current_sign_in_ip.to_s}"
      end
    end
    default_actions
  end
  controller do
    def update
      @user = User.find(params[:id])
      respond_to do |format|
        if @user.update_without_password(params[:user])
          format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
    def scoped_collection
      User.includes(:subscriptions, :roles)
    end
  end
end