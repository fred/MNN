class RegistrationsController < Devise::RegistrationsController

  protected
  
  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    edit_user_registration_path(protocol: 'https')
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    edit_user_registration_path(protocol: 'https')
  end

end