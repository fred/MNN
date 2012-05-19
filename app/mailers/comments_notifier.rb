class CommentsNotifier < ActionMailer::Base
  self.delivery_method = :smtp

  def new_comment(comment_id)
    @comment = Comment.includes(:owner).find(comment_id)
    @url  = url_for(admin_comment_path(@comment, only_path: false, protocol: 'http'))
    @subscriptions = CommentSubscription.where("email is not NULL").all
    @emails_list = @subscriptions.map{|t| t.email}.join(",")
    @@smtp_settings = {
      domain:    "worldmathaba.com",
      address:   "localhost",
      port:      25
     }
    mail(
      from:     "WorldMathaba <inbox@worldmathaba.net>",
      sender:   "inbox@worldmathaba.net",
      reply_to: "inbox@worldmathaba.net",
      to:       "inbox@worldmathaba.net",
      bcc:      @emails_list,
      subject:  "[New Comment] by #{@comment.display_name}",
      tag:      "comment-notification"
    )
  end
end
