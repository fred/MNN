module UsersHelper

  def user_avatar(user)
    user.main_image(:thumb)
  end

end
