# USER
ActiveAdmin.register AdminUser do
  controller.authorize_resource
  config.comments = false
  menu :parent => "Members", :priority => 24, :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, AdminUser)
  }
  form :partial => "form"
  # show do
  #   render "show"
  # end
  index do
    column :id
    column :name
    column :email
    column :ranking
    column :role_titles
    column :type
    column "Subscribed", :sortable => false do |user|
      user.has_subscription?
    end
    column "Logins", :sign_in_count
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
  end
end