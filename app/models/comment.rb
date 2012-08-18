class Comment < ActiveRecord::Base
  opinio counter_cache: true
  include Rakismet::Model
  # AKISMET parameters:
  # author        : name submitted with the comment
  # author_url    : URL submitted with the comment
  # author_email  : email submitted with the comment
  # comment_type  : Defaults to comment but you can set it to trackback, pingback, or something more appropriate
  # content       : the content submitted
  # permalink     : the permanent URL for the entry the comment belongs to
  # user_ip       : IP address used to submit this comment
  # user_agent    : user agent string
  # referrer      : referring URL (note the spelling)
  
  validates_presence_of :body
  attr_accessible :body, :commentable_id, :commentable_type, :approved, :marked_spam, :suspicious, :approved_by
  
  # belongs_to :user
  belongs_to :approving_user, foreign_key: :approved_by, class_name: "User"
  
  before_create :check_for_spam
  after_create  :email_notify, :touch_commentable

  delegate :name, to: :owner, allow_nil: true


  def touch_commentable
    if !marked_spam? && commentable && commentable.respond_to?(:update_column)
      commentable.update_column(:last_commented_at, DateTime.now)
    end
  end

  # Send the email notifications 15 seconds after creation
  def email_notify
    if Rails.env.production?
      CommentsNotifier.delay_for(15).new_comment(self.id)
    else
      CommentsNotifier.new_comment(self.id).deliver
    end
  end

  def check_for_spam
    if !Rails.env.test? && self.spam?
      self.marked_spam = true
      self.approved = false
    else
      self.marked_spam = false
      self.approved = true
    end
    true
  end

  def commentable_title
    if self.commentable
      self.commentable.title
    else
      ""
    end
  end

  def display_name
    self.owner.title if self.owner
  end
  
  def author
    self.owner.title if self.owner
  end

  def author_email
    if self.owner
      self.owner.email
    else
      ""
    end
  end
  
  def akismet_attributes
    {
      key:                  AKISMET_KEY,
      blog:                 'http://worldmathaba.net',
      user_ip:              user_ip,
      user_agent:           user_agent,
      comment_author:       author,
      comment_author_email: author_email,
      comment_content:      body
    }
  end
  
  
  # Returns the last 10 approved comments
  def self.recent(limit=10)
    where(approved: true).
    where(suspicious: false).
    where(marked_spam: false).
    order("updated_at DESC").
    includes([:owner, :commentable]).
    limit(limit).
    all
  end

  # Returns the last 10 pending comments
  def self.pending(limit=10)
    where(approved: false).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 suspicious comments
  def self.suspicious(limit=10)
    where(suspicious: true).
    where(marked_spam: false).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 comments marked as spam
  def self.as_spam(limit=10)
    where(marked_spam: true).
    includes([:owner, :commentable]).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  
end
