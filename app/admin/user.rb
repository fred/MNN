# USER
ActiveAdmin.register User do
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
      @user = User.find(params[:id])
      respond_to do |format|
        if @item.update_without_password(params[:user])
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