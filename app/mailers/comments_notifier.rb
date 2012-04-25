class CommentsNotifier < ActionMailer::Base
  self.delivery_method = :test

  default from: "inbox@worldmathaba.net"
  # include Resque::Mailer
  
  def new_comment(comment_id)
    @comment = Comment.includes(:owner).find(comment_id)
    @url  = url_for(admin_comment_path(@comment, :only_path => false, :protocol => 'http'))
    @subscriptions = CommentSubscription.where("email is not NULL").all
    @emails = @subscriptions.map{|t| t.email}.join(",")
    
    @@smtp_settings = {
      :domain         => "worldmathaba.com",
      :address        => "localhost",
      :port           => 25
     }
    unless @subscriptions.empty?
      mail(
        :sender => "inbox@worldmathaba.net",
        :from => "WorldMathaba.net <inbox@worldmathaba.net>",
        :reply_to => "inbox@worldmathaba.net",
        :to => "inbox@worldmathaba.net",
        :bcc => @emails,
        :subject => "[New Comment] by #{@comment.display_name}",
        :tag => "user-#{@comment.owner.id}"
      )
    end
  end
end
