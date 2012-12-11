module UsersHelper

  def user_avatar(user)
    user.main_image(:thumb)
  end

  def karma_medals(user)
  end
end
