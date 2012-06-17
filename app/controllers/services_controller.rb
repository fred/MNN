class ServicesController < ApplicationController
  
  def create
    begin
      @user = User.find_or_create_from_oauth(auth_hash, current_user)
      if @user.persisted?
        flash[:notice] =  "Welcome! You are signed in."
        sign_in_and_redirect @user, 
          event: :authentication,
          notice: "Welcome! You are signed in."
      else
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    rescue Exception => e
      render :text => e
    end
  end
  
  def failure
    render :text => auth_hash
  end

  def destroy
    logout_user
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end