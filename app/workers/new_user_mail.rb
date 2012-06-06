class NewUserMail < BaseWorker

  def perform(user_id)
    UserMailer.new_user(user_id).deliver
  end
end