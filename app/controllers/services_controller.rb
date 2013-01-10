class ServicesController < ApplicationController
  
  def create
    begin
      @user = User.find_or_create_from_oauth(auth_hash)
      Rails.logger.info("  Oauth: #{auth_hash.inspect}")
      Rails.logger.info("  Oauth: found user: #{@user.id}") if @user
      if @user.persisted?
        Rails.logger.info("  Oauth: User persisted, logging in user: #{@user.id}")
        flash[:notice] =  "Welcome! You are now signed in."
        sign_in_and_redirect @user, 
          event: :authentication,
          notice: "Welcome! You are now signed in."
      else
        flash[:error] = "Sorry, there was an error and we could not login you in with #{auth_hash['provider']}."
        Rails.logger.info("  Oauth: failed: #{request.env['omniauth.auth']}")
        Rails.logger.info("  Oauth: user valid?: #{@user.valid?}") if @user
        Rails.logger.info("  Oauth: user persisted?: #{@user.persisted?}") if @user
        session["devise.facebook_data"] = auth_hash
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