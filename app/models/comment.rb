class Comment < ActiveRecord::Base
  # opinio
  include Rakismet::Model  
  # author        : name submitted with the comment
  # author_url    : URL submitted with the comment
  # author_email  : email submitted with the comment
  # comment_type  : Defaults to comment but you can set it to trackback, pingback, or something more appropriate
  # content       : the content submitted
  # permalink     : the permanent URL for the entry the comment belongs to
  # user_ip       : IP address used to submit this comment
  # user_agent    : user agent string
  # referrer      : referring URL (note the spelling)
  
  # belongs_to :user
  belongs_to :approving_user, :foreign_key => :approved_by, :class_name => "User"
  
  ### Askimet helpers ###
  def author
    self.user.name if self.user
  end
  def author_email
    self.user.email if self.user
  end
  def content
    self.user.body if self.user
  end
  
  def akismet_attributes
    {
      :key                  => AKISMET_KEY,
      :blog                 => 'http://mnn.herokuapp.com',
      :user_ip              => user_ip,
      :user_agent           => user_agent,
      :comment_author       => name,
      :comment_author_email => email,
      :comment_author_url   => site_url,
      :comment_content      => content
    }
  end
  
  
  # Returns the last 10 approved comments
  def self.recent(limit=10)
    where(:approved => true).
    order("updated_at DESC").
    limit(limit).
    all
  end

  # Returns the last 10 pending comments
  def self.pending(limit=10)
    where(:approved => false).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 suspicious comments
  def self.suspicious(limit=10)
    where(:suspicious => true).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 comments marked as spam
  def self.as_spam(limit=10)
    where(:marked_spam => true).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  
end
