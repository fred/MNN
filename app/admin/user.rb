# USER
ActiveAdmin.register User do
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
      row "Facebook", &:fbuid?
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
      row "Last IP", &:last_sign_in_ip
      row "Current IP", &:current_sign_in_ip
      row :created_at
      row :updated_at
    end
  end


  index do
    column :id
    column "Avatar", sortable: false do |user|
      image_tag user.main_image(:thumb)
    end
    column :name
    column :email
    column "FB", :fbuid?, sortable: :fbuid do |user|
      bool_symbol user.fbuid?
    end
    column "Facebook", sortable: false do |user|
      if user.facebook.present?
        link_to "Facebook", user.facebook
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
    column "Last IP", :last_sign_in_ip
    column "Current IP", :current_sign_in_ip
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
  end
end