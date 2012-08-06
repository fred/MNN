class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models

  DEFAULT_LOCALE = 'en'

  attr_protected :user_id, :slug, :updated_by, :deleted_at

  attr_accessor :updated_reason, :share_twitter, :send_emails, :existing_attachment_id

  # Versioning System
  has_paper_trail meta: { tag: :updated_reason }

  # Comment System
  opinio_subjectum conditions: {approved: true}, include: :owner

  # Permalink URLS
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Relationships
  belongs_to :user,       inverse_of: :items,  counter_cache: true
  belongs_to :category,   inverse_of: :items
  belongs_to :language,   inverse_of: :items
  has_one    :item_stat,  inverse_of: :item

  has_many  :attachments, as: :attachable
  has_many  :job_stats,   as: :processable
  has_many  :twitter_shares,   dependent: :destroy
  has_many  :email_deliveries, dependent: :destroy

  has_and_belongs_to_many :tags, join_table: "taggings", 
    foreign_key: "taggable_id", association_foreign_key: "tag_id"

  has_and_belongs_to_many :general_tags, join_table: "taggings", 
    foreign_key: "taggable_id", association_foreign_key: "tag_id"

  has_and_belongs_to_many :region_tags, join_table: "taggings",
    foreign_key: "taggable_id", association_foreign_key: "tag_id"

  has_and_belongs_to_many :country_tags, join_table: "taggings",
    foreign_key: "taggable_id", association_foreign_key: "tag_id"

  # Nested Attributes
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: lambda { |t| t['image'].nil? }
  
  # Validations
  validates_presence_of :title, :abstract, :category_id, :published_at
  validates_presence_of :body, if: Proc.new { |item| item.youtube_id.blank? }
  validates_presence_of :published_at
  
  # Filter hooks
  before_save   :clear_bad_characters
  before_save   :create_twitter_share
  before_save   :dup_existing_attachment
  before_save   :send_email_deliveries
  before_save   :process_sitemap_job
  before_update :set_status_code
  before_create :build_stat
  after_create  :set_custom_slug


  # Some Basic Scopes for finder chaining
  scope :draft,         where(draft: true)
  scope :not_draft,     where(draft: false)
  scope :original,      where(original: true)
  scope :not_original,  where(original: false)
  scope :highlight,     where(featured: true)
  scope :not_highlight, where(featured: false)
  scope :sticky,        where(sticky: true)
  scope :not_sticky,    where(sticky: false)
  scope :with_comments, where("comments_count > 0")

  ################
  ####  SOLR  ####
  ################
  # searchable auto_index: false, auto_remove: false do # if using QUEUE
  searchable do
    text :title, boost: 2.4
    text :abstract, boost:  1.6
    text :keywords, boost:  5.0
    text :category_title, boost:  1.8
    text :author_name, boost:  2.2
    text :author_email
    text :article_source
    text :source_url
    text :body
    text :youtube_id
    integer :id
    integer :category_id, references: Category
    integer :language_id, references: Language
    integer :user_id,     references: User
    boolean :draft
    boolean :featured
    boolean :sticky
    time :updated_at
    time :published_at
    # boost { 3.0 if featured }
    text :tags do
      tags.map { |tag| tag.title }
    end
  end

  # if Rails.env.production?
  # after_commit   :queue_solr_update
  # before_destroy :queue_solr_remove
  # end


  ######################
  ### Instance Methods
  ######################

  def after_initialize
    self.draft ||= true
    self.published_at ||= Time.zone.now  # will set the default value only if it's nil
    self.expires_on   ||= Time.zone.now+10.years
  end

  def corrected_updated_at
    if self.published_at && (self.published_at > self.updated_at)
      self.published_at
    else
      self.updated_at
    end
  end

  # generate slugs once and then treat them as read-only
  def should_generate_new_friendly_id?
    new_record?
  end

  def set_custom_slug
    update_column(:slug, custom_slug)
  end

  def custom_slug
    "#{self.id}-#{self.title.parameterize}"
  end

  def clear_bad_characters
    # self.body.gsub!("&lsquo;", "&#39;")
    # self.body.gsub!("&rsquo;", "&#39;")
    # self.body.gsub!("&ldquo;", "&#34;")
    # self.body.gsub!("&rdquo;", "&#34;")
    # self.body.gsub!("&ndash;", "&#45;")
    # self.body.gsub!("&mdash;", "&#45;")
    # self.body.gsub!("&#180;", "&#39;")
    # self.body.gsub!("&#96;", "&#39;")
    self.body.to_s.gsub!("&lsquo;", "\'")
    self.body.to_s.gsub!("&rsquo;", "\'")
    self.body.to_s.gsub!("&ldquo;", "\"")
    self.body.to_s.gsub!("&rdquo;", "\"")
    self.body.to_s.gsub!("&ndash;", "-")
    self.body.to_s.gsub!("&mdash;", "-")
    self.body.to_s.gsub!("&#180;", "\'")
    self.body.to_s.gsub!("&#96;", "\'")
    self.body.to_s.gsub!("&nbsp;", " ")
    self.body.to_s.gsub!("&hellip;", "...")
    true
  end



  ##############
  #### JOBS ####
  ##############
  
  def enqueue_time
    if published?
      Time.now+3.minutes
    else
      self.published_at + 3.minutes
    end
  end

  def email_delivery_sent?
    if !self.email_deliveries.empty? && self.email_deliveries.first.send_at &&
       (self.email_deliveries.first.send_at < Time.now)
      true
    else
      false
    end
  end

  def email_delivery_queued?
    if !self.email_deliveries.empty? && self.email_deliveries.first.send_at &&
       (self.email_deliveries.first.send_at > Time.now)
      true
    else
      false
    end
  end

  def email_delivery_queued_at
    if self.email_delivery_queued?
      self.email_deliveries.first.send_at
    else
      nil
    end
  end

  def send_email_deliveries
    if !self.draft && self.email_deliveries.empty? && (self.send_emails == "1" or self.send_emails == true)
      Rails.logger.info("  Email-Delivery: Creating Email Delivery for item: #{self.id}")
      self.email_deliveries << EmailDelivery.new(send_at: self.enqueue_time)
    end
    true
  end

  def posted_to_twitter?
    if !self.twitter_shares.empty? && self.twitter_shares.first.processed_at
      true
    else
      false
    end
  end

  # Creates the twitter sharing JOB
  # checks the item publication date and set the time to send the twitter share
  # Set Posting tim to be 3 minutes after the publication_date of item.
  def create_twitter_share
    if !self.draft && (self.share_twitter.to_s=="1" or self.share_twitter==true) && self.twitter_shares.empty?
      Rails.logger.info("  Twitter: Creating Twitter Share for item: #{self.id}")
      self.twitter_shares << TwitterShare.new(enqueue_at: self.enqueue_time, status: 'queued')
    end
    true
  end

  def twitter_status
    url  = self.title.truncate(115)
    url += " "
    url += url_for(item_path(self, host: "worldmathaba.net", only_path: false, protocol: 'http'))
    return url
  end

  def sitemap_jobs
    job_stats.where(job_name: 'sitemap')
  end

  # Queue up sitemap generation after 3 minutes
  def process_sitemap_job
    if !self.draft && self.sitemap_jobs.empty?
      Rails.logger.info("  Sitemap: Scheduling sitemap generation for item: #{self.id}")
      self.job_stats << JobStat.new(job_name: 'sitemap', enqueue_at: enqueue_time)
    end
  end

  def youtube_height
    if youtube_res
      youtube_res.split("x").first
    else
      nil
    end
  end
  def youtube_width
    if youtube_res
      youtube_res.split("x").last
    else
      nil
    end
  end


  def main_image
    att = self.attachments.last
    if att.existing_attachment
      return att.existing_attachment
    else
      return att
    end
  end

  def main_image_cache_key
    # give 10 seconds delay for image uploading and processing
    if self.has_image? && self.main_image.updated_at.to_i > (self.updated_at.to_i+10)
      self.main_image.updated_at.to_s(:number)
    else
      ""
    end
  end

  def comment_cache_key
    if self.comments_count > 0 && self.last_commented_at
      self.last_commented_at.to_s(:number)
    else
      ""
    end
  end

  def has_image?
    if !self.attachments.empty? && self.attachments.last.image
      true
    else
      false
    end
  end

  # Returns an improved cache_key that includes the last image on the item
  def cache_key_full
    str = self.cache_key 
    str += "/"
    str += self.main_image_cache_key
    str += self.comment_cache_key
  end

  def tag_list(join=", ")
    array = []
    self.tags.each do |t|
      array << t.title
    end
    return array.join(join)
  end

  def build_stat
    self.item_stat = ItemStat.new(views_counter: 0)
  end

  # Set to draft automatically upon creation
  def set_status_code
    if self.published_at && (self.published_at > Time.zone.now)
      self.status_code = "Not Live"
    else
      self.status_code = "Live"
    end
  end

  def admin_permalink
    admin_item_path(self)
  end

  def published?
    !self.draft && (self.published_at.to_i < Time.now.to_i)
  end

  def user_public_display_name
    if self.user
      self.user.public_display_name
    else
      "anonymous"
    end
  end

  def language_title_short
    if self.language
      self.language.locale
    else
      DEFAULT_LOCALE
    end
  end

  def category_title
    if self.category
      self.category.title
    else
      "Uncategorized"
    end
  end

  def language_title
    if self.language
      self.language.description
    else
      "en"
    end
  end

  # Returns the article's author formated name
  def user_title
    if self.user
      self.user.public_display_name
    elsif self.author_name && !self.author_name.empty?
      self.author_name
    else
      "WorldMathaba"
    end
  end

  # Returns the article's author formated email
  def user_email
    if self.user && self.user.email
      self.user.email
    else
      "inbox@worldmathaba.net"
    end
  end

  def keywords_list
    self.keywords.to_s.split.join(',')
  end

  def meta_keywords
    "#{self.keywords_list}, #{self.category_title}, #{self.tag_list}"
  end

  # This builds the solr keyword for related articles
  def keyword_for_solr
    # @str = self.keywords.to_s.gsub(","," ")
    # @str += " "
    # @str += self.tag_list(" ")
    # @str
    self.keywords.to_s.gsub(","," ")
  end

  # Return Similar listings based on keywords only.
  def solr_similar(limit=6)
    # IF no bedrooms or bathrooms
    # Item.solr_search do
    Item.solr_search(include: [:attachments]) do
      fulltext self.keyword_for_solr
      if self.language_id
        with(:language_id, self.language_id)
      end
      without(:id, self.id)
      with(:draft, false)
      paginate page: 1, per_page: limit
    end
  end

  def localized_domain
    if Rails.env.production?
      if self.language_title_short.match(DEFAULT_LOCALE)
        "worldmathaba.net"
      else
        "#{self.language_title_short}.worldmathaba.net"
      end
    else
      "mathaba.dev"
    end
  end


  ####################
  ### CLASS METHODS
  ####################

  def self.default_locale
    I18n.locale.to_s || DEFAULT_LOCALE
  end

  def self.published
    where("published_at < ?", DateTime.now)
  end

  def self.queued
    where("published_at > ?", DateTime.now)
  end

  def self.last_item
    published.order("updated_at DESC").first
  end

  # Returns the most popular Items in the last N days
  def self.popular(lim=5, n=15)
    published.
    includes(:attachments, :item_stat).
    where("items.published_at > ?", (DateTime.now - n.days)).
    order("item_stats.views_counter DESC").
    limit(lim)
  end

  # Returns the most Commented Items in the last N days
  def self.recently_commented(lim=5, n=30)
    published.
    where("items.published_at > ?", (DateTime.now - n.days)).
    where("items.comments_count > 0").
    where("items.last_commented_at is NOT NULL").
    includes(:attachments, :comments, :item_stat).
    order("items.last_commented_at DESC").
    limit(lim)
  end

  # Returns the most Commented Items in the last N days
  def self.most_commented(lim=5, n=30)
    published.
    where("items.published_at > ?", (DateTime.now - n.days)).
    where("comments_count > 0").
    order("comments_count DESC").
    includes(:attachments, :comments, :item_stat).
    limit(lim)
  end


  def self.news_for_sitemap(lim=100, hrs=96)
    self.for_sitemap(lim,hrs).where(original: true)
  end

  # Only show items in the past 2 days in sitemaps
  def self.for_sitemap(lim=100, hrs=48)
    published.
    where("published_at > ?", DateTime.now-(hrs.hours)).
    not_draft.
    order("published_at DESC").
    limit(lim)
  end

  def self.localized
    language = Language.where(locale: default_locale).first
    if language
      where(language_id: language.id)
    else
      where('')
    end
  end

  # Returns the top sticky item
  # Used on the Front End, joining attachments
  def self.top_sticky
    published.
    localized.
    where(draft: false, sticky: true).
    order("published_at DESC").
    includes(:attachments).
    first
  end

  # Returns top Highlight Items
  # Used on the Front End, joining attachments
  def self.highlights(limit=6,offset=0)
    published.
    localized.
    where(draft: false, featured: true, sticky: false).
    order("published_at DESC").
    limit(limit).
    includes(:attachments).
    offset(offset).
    all
  end

  # Returns the last 10 approved items (not draft anymore)
  # Used on the dashboard
  def self.recent_updated(limit=10)
    published.
    where(draft: false).
    where("updated_at > created_at").
    order("updated_at DESC").
    limit(limit).
    all
  end

  # Returns the last 10 approved items (not draft anymore)
  # Used on the Admin Dashboard
  def self.recent(limit=10)
    published.
    order("id DESC").
    limit(limit).
    all
  end

  # Returns the last 10 draft items
  # Used on the Admin Dashboard
  def self.recent_drafts(limit=10)
    draft.
    order("updated_at DESC").
    limit(limit).
    all
  end

  # Returns the last 10 pending items (not draft anymore)
  # Used on the Admin Dashboard
  def self.pending(limit=10)
    where(published_at: nil).
    not_draft.
    order("updated_at DESC").
    limit(limit).
    all
  end

  # Imports an XML output from wordpress
  def self.import_wordpress_xml
    require 'nokogiri'
    file = File.join(Rails.root, "config", "wp.xml")
    doc = Nokogiri::HTML(open(file))
    items = doc.xpath("//item")
    user = User.first

    items.each do |item|
      item_id = item.xpath("guid").first.to_str
      title = item.xpath("title").first.to_str
      pubdate = item.xpath("pubdate").first.to_str
      body = item.xpath("encoded").first.to_str
      author_name = item.xpath("creator").first.to_str

      puts "**** item_id: #{item_id} ****"
      if pubdate
        date = DateTime.parse(pubdate)
        if date
          time = date.to_time
        else
          time = Time.now
        end
      end

      Item.create(
        title: title,
        published_at: time,
        body: body,
        author_name: author_name,
        source_url: item_id,
        draft: true,
        featured: false,
        user_id: user.id
      )
    end
  end
  
  
  
  protected

    # From https://gist.github.com/1282013
    def queue_solr_update
      SolrUpdate.perform_async(self.class.to_s, id)
    end
    def queue_solr_remove
      SolrRemove.perform_async(self.class.to_s, id)
    end

    def dup_existing_attachment
      if self.existing_attachment_id && \
      self.existing_attachment_id.to_s.match("[0-9]{1,}") && \
      att = Attachment.find(self.existing_attachment_id) 
        self.attachments << Attachment.new(parent_id: att.id)
      end
    end

end


