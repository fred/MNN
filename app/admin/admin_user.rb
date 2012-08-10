# USER
ActiveAdmin.register AdminUser do
  before_filter only: :index do
    @per_page = 12
  end
  controller.authorize_resource
  config.comments = false
  menu parent: "Members", priority: 24, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, AdminUser)
  }
  form partial: "form"
  show title: :title do
    attributes_table do
      row :id
      row :email
      row :name
      row :registration_role
      row :provider
      row :time_zone
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
        link_to user.last_sign_in_ip,
          "http://www.geoiptool.com/en/?IP=#{user.last_sign_in_ip}"
      end
      row "Current IP" do |user|
        link_to user.current_sign_in_ip,
          "http://www.geoiptool.com/en/?IP=#{user.current_sign_in_ip}"
      end
      row :created_at
      row :updated_at
    end
    render "user_comments"
  end
  index do
    id_column
    column "Avatar", sortable: false do |user|
      image_tag(user.main_image(:thumb))
    end
    column :name
    column :email
    column :provider
    column :time_zone
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
      link_to user.last_sign_in_ip,
        "http://www.geoiptool.com/en/?IP=#{user.last_sign_in_ip}"
    end
    column "Current IP" do |user|
      link_to user.current_sign_in_ip,
        "http://www.geoiptool.com/en/?IP=#{user.current_sign_in_ip}"
    end
    default_actions
  end
  controller do
    def update
      @admin_user = AdminUser.find(params[:id])
      authorize! :update, @admin_user
      respond_to do |format|
        if @admin_user.update_without_password(params[:admin_user])
          format.html { redirect_to admin_users_path, notice: 'AdminItem was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @admin_user.errors, status: :unprocessable_entity }
        end
      end
    end
    def scoped_collection
      AdminUser.includes(:subscriptions, :roles)
    end
  end
end