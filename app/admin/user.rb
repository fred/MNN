# USER
ActiveAdmin.register User do
  config.clear_sidebar_sections!
  before_filter only: :index do
    @per_page = 12
  end
  controller.authorize_resource
  config.comments = false
  menu parent: "Members", priority: 24, label: "Users", if: lambda{|tabs_renderer|
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
      row "Logged in" do |user|
        user.current_sign_in_at.to_s(:short)
      end
      row "Last Seen" do |user|
        user.last_sign_in_at.to_s(:short)
      end
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
      row "Updated" do |user|
        user.updated_at.to_s(:large)
      end
      row "Created" do |user|
        user.created_at.to_s(:large)
      end
      row "Articles" do |user|
        user.items_count
      end
      row "Original Articles" do |user|
        user.original_items_count
      end
      row "Voted Karma" do |user|
        user.karma
      end
      row "Comments Karma" do |user|
        user.comments_karma
      end
      row "Total Site Karma" do |user|
        user.full_karma
      end
      row "Trusted for comments" do |user|
        bool_symbol user.comments_trusted?
      end
    end
    render "user_comments"
  end

  index title: "Users" do
    id_column
    column "Avatar", sortable: false do |user|
      image_tag(user.main_image(:thumb), class: 'user-avatar-mini')
    end
    column :name
    column :email do |user|
      user.email.truncate(20)
    end
    column :karma, sortable: false
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
    column :type
    column "Logins", :sign_in_count
    column "Last Login" do |user|
      user.current_sign_in_at.to_s(:short)
    end
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
      authorize! :update, @user
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
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_access_denied_path, alert: exception.message
    end
  end
end