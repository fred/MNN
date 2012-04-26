class SubscriptionMailer < ActionMailer::Base

  # include Resque::Mailer
  
  # default from: "WorldMathaba <inbox@worldmathaba.net>"
  
  def new_item_email(item_id)
    @item = Item.find(item_id)
    @url  = url_for(item_path(@item, :only_path => false, :protocol => 'http'))
    @subscriptions = Subscription.where("email is not NULL AND item_id is NULL").all
    @emails_list = @subscriptions.map{|t| t.email}.join(",")
    
    unless @subscriptions.empty?
      mail(
        :sender => "inbox@worldmathaba.net",
        :from => "WorldMathaba.net <inbox@worldmathaba.net>",
        :reply_to => "inbox@worldmathaba.net",
        :to => "inbox@worldmathaba.net",
        :bcc => @emails_list,
        :subject => "[New post] #{@item.title}",
        :tag => "item_subscription"
      )
    end
  end
end
