class CommentSubscription < Subscription

  def self.without_user(owner_id)
    where("user_id != ?", owner_id)
  end
end
