require 'resque-history'

class MailerQueue
  extend Resque::Plugins::History
  @queue = :email
  @max_history = 50
  
  def self.perform(user_id)
    UserMailer.new_user(user_id).deliver
  end
end