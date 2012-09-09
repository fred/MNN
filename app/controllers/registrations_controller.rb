class RegistrationsController < Devise::RegistrationsController


  # def create
  #   @user = User.new(params[:user])

  #   if params[:user]
  #     params[:user].delete(:roles)      if params[:user][:roles].present?
  #     params[:user].delete(:role_ids)   if params[:user][:role_ids].present?
  #     params[:user].delete(:upgrade)    if params[:user][:upgrade].present?
  #   end

  #   respond_to do |format|
  #     if @user.save
  #       flash[:notice] = _("Your Account Was successfully Created")
  #       redirect_to stored_location_for(:user) || edit_user_registration_path(protocol: http_protocol)
  #     else
  #       format.html { render action: "new" }
  #     end
  #   end
  # end

  def update
    @user = User.find(current_user.id)
    
    params[:user].delete(:password) if params[:user] && params[:user][:password].empty?
    params[:user].delete(:password_confirmation) if params[:user] && params[:user][:password_confirmation].empty?

    if @user.update_attributes(params[:user])
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path(protocol: http_protocol)
      flash[:success] = _("Account Successfully Updated")
    else
      flash[:notice] = "There was an error updating your account"
      render "edit"
    end
  end

  protected
  
  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    edit_user_registration_path(protocol: http_protocol)
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    edit_user_registration_path(protocol: http_protocol)
  end

end