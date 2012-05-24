# USER
ActiveAdmin.register User do
  controller.authorize_resource
  config.comments = false
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
      row :fbuid
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
    column :fbuid
    column "Facebook", sortable: false do |user|
      if user.facebook
        link_to "Facebook", user.facebook
      end
    end
    column :role_titles
    column :type
    column "Subscribed", sortable: false do |user|
      user.has_subscription?
    end
    column "Logins", :sign_in_count
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