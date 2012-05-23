class SubscriptionMailer < ActionMailer::Base
  
  def new_item_email(item_id)
    @item = Item.find(item_id)
    @url  = url_for(item_path(@item, ref: "email", only_path: false, protocol: 'http'))
    @subscriptions = Subscription.where("email is not NULL AND item_id is NULL").all
    @emails_list = @subscriptions.map{|t| t.email}.join(",")
    mail(
      from:     "WorldMathaba <inbox@worldmathaba.net>",
      sender:   "inbox@worldmathaba.net",
      reply_to: "inbox@worldmathaba.net",
      to:       "inbox@worldmathaba.net",
      bcc:      @emails_list,
      subject:  "[New post] #{@item.title}",
      tag:      "item_subscription"
    )
  end

end
