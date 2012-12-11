class CommentsNotifier < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  self.delivery_method = :smtp if Rails.env.production?

  def to_admin(comment_id)
    @comment = Comment.includes(:owner).find(comment_id)
    @url  = url_for(admin_comment_path(@comment, only_path: false, protocol: 'http'))
    @subscriptions = CommentSubscription.for_admin
    @emails_list = @subscriptions.map{|t| t.email}.join(",")
    @@smtp_settings = {
      domain:    "worldmathaba.com",
      address:   "localhost",
      port:      25
    } if @comment && Rails.env.production?
    mail(
      from:     "WorldMathaba <inbox@worldmathaba.net>",
      sender:   "inbox@worldmathaba.net",
      reply_to: "inbox@worldmathaba.net",
      to:       "inbox@worldmathaba.net",
      bcc:      @emails_list,
      subject:  "[New Comment] by #{@comment.display_name}"
    )
  end

  def to_users(comment_id)
    @comment = Comment.includes(:owner, :commentable).find(comment_id)
    @item = @comment.commentable
    @url  = url_for(item_path(@item, only_path: false, protocol: 'http'))
    @emails_list = @item.comment_subscriptions.without_user(@comment.owner_id).map{|t| t.user.email}.join(",")
    @@smtp_settings = {
      domain:    "worldmathaba.com",
      address:   "localhost",
      port:      25
    } if @comment && Rails.env.production?
    mail(
      from:     "WorldMathaba <inbox@worldmathaba.net>",
      sender:   "inbox@worldmathaba.net",
      reply_to: "inbox@worldmathaba.net",
      to:       "inbox@worldmathaba.net",
      bcc:      @emails_list,
      subject:  "[New Comment] by #{@comment.display_name}"
    )
  end
end
