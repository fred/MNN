# USER
ActiveAdmin.register AdminUser do
  controller.authorize_resource
  config.comments = false
  menu :parent => "Members", :priority => 24
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
    column "Logins", :sign_in_count
    default_actions
  end
  controller do
    def update
      @admin_user = AdminUser.find(params[:id])
      respond_to do |format|
        if @admin_user.update_without_password(params[:admin_user])
          format.html { redirect_to admin_users_path, notice: 'Item was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @admin_user.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end