class CommentsNotifier < ActionMailer::Base
  default from: "WorldMathaba <inbox@worldmathaba.net>"

  def new_comment(comment_id)
    @comment = Comment.includes(:owner).find(comment_id)
    @url  = url_for(admin_comment_path(@comment, only_path: false, protocol: 'http'))
    @subscriptions = CommentSubscription.where("email is not NULL").all
    @emails_list = @subscriptions.map{|t| t.email}.join(",")

    unless @subscriptions.empty?
      mail(
        sender:   "inbox@worldmathaba.net",
        reply_to: "inbox@worldmathaba.net",
        to:       "inbox@worldmathaba.net",
        bcc:      @emails_list,
        subject:  "[New Comment] by #{@comment.display_name}",
        tag:      "comment-notification"
      )
    end
  end
end
