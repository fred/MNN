class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models

  attr_protected :user_id, :slug, :updated_by, :deleted_at

  attr_accessor :updated_reason, :share_twitter, :send_emails

  # Versioning System
  has_paper_trail meta: { tag: :updated_reason }

  # Comment System
  opinio_subjectum conditions: {approved: true}, include: :owner

  # Permalink URLS
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Relationships
  belongs_to :user, counter_cache: true
  belongs_to :category
  belongs_to :language
  has_one  :item_stat
  has_many :attachments, as: :attachable
  has_many :twitter_shares,   dependent: :destroy
  has_many :email_deliveries, dependent: :destroy

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
  validates_presence_of :title, :category_id, :published_at
  validates_presence_of :body, if: Proc.new { |item| item.youtube_id.blank? }
  validates_presence_of :published_at
  validate :record_freshness
  
  # Filter hooks
  before_save   :clear_bad_characters
  before_save   :create_twitter_share
  before_update :set_status_code
  before_create :build_stat
  before_save   :send_email_deliveries
  after_create  :sitemap_refresh
  
  ################
  ####  SOLR  ####
  ################
  # searchable auto_index: false, auto_remove: false do # if using resque
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

  # if Rails.env.production? # and using solr resque?
  # after_commit   :resque_solr_update
  # before_destroy :resque_solr_remove
  # end


  ######################
  ### Instance Methods
  ######################

  def after_initialize
    self.draft ||= true
    self.published_at ||= Time.zone.now  # will set the default value only if it's nil
    self.expires_on   ||= Time.zone.now+10.years
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
    self.body.gsub!("&lsquo;", "\'")
    self.body.gsub!("&rsquo;", "\'")
    self.body.gsub!("&ldquo;", "\"")
    self.body.gsub!("&rdquo;", "\"")
    self.body.gsub!("&ndash;", "-")
    self.body.gsub!("&mdash;", "-")
    self.body.gsub!("&#180;", "\'")
    self.body.gsub!("&#96;", "\'")
    self.body.gsub!("&nbsp;", " ")
    self.body.gsub!("&hellip;", "...")
    true
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
      if self.published_at.to_i < Time.now.to_i
        send_time = Time.now+180
      else
        send_time = self.published_at+180
      end
      self.email_deliveries << EmailDelivery.new(send_at: send_time)
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
      self.twitter_shares << TwitterShare.new(enqueue_at: self.enqueue_time)
    end
    true
  end

  def twitter_status
    url  = self.title.truncate(115)
    url += " "
    url += url_for(item_path(self, host: "worldmathaba.net", only_path: false, protocol: 'http'))
    return url
  end

  # Queue up sitemap generation after 3 minutes
  def sitemap_refresh
    if !self.draft && Rails.env.production?
      Resque.enqueue_at(self.enqueue_time, SitemapQueue) 
    end
  end


  def enqueue_time
    if self.published_at
      self.published_at+180
    else
      Time.now+180
    end
  end


  # WORKING
  def record_freshness
    unless self.new_record?
      last_date = Item.find(self.id).updated_at.to_f
      self_date = self.updated_at.to_f
      if last_date > self_date
        errors.add(:title, "Item is not fresh. Someone else have updated this while you were editing it")
      end
    end
  end

  # NOT WORKING
  def record_freshness_by_version
    unless self.new_record?
      last_version = self.versions.last.created_at.to_f
      current_date = self.updated_at.to_f
      if last_version >= current_date
        errors.add(:title, "Item is not fresh. Someone else have updated this while you were editing it")
      end
    end
  end

  def main_image
    self.attachments.last
  end

  def main_image_cache_key
    # give 10 seconds delay for image uploading and processing
    if self.has_image? && self.main_image.updated_at.to_i > (self.updated_at.to_i+10)
      self.main_image.updated_at.to_s(:number)
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
    self.cache_key + "/" + self.main_image_cache_key
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
    self.published_at.to_i < Time.now.to_i
  end


  def language_title_short
    if self.language
      self.language.locale
    else
      "en"
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
    if self.user && !self.user.name.empty?
      self.user.name
    elsif self.author_name && !self.author_name.empty?
      self.author_name
    else
      "mnn"
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

  ####################
  ### CLASS METHODS
  ####################

  # Returns the most popular Items in the last N days
  def self.popular(lim=5, n=15)
    published.
    includes(:attachments).
    joins(:item_stat).
    where("items.published_at > ?", (DateTime.now - n.days)).
    order("item_stats.views_counter DESC").
    limit(lim)
  end

  # Returns the most Commented Items in the last N days
  def self.recently_commented(lim=5, n=30)
    published.
    where("items.published_at > ?", (DateTime.now - n.days)).
    where("comments_count > 0").
    joins(:comments).
    order("comments.id DESC").
    includes(:attachments).
    limit(lim)
  end

  # Returns the most Commented Items in the last N days
  def self.most_commented(lim=5, n=30)
    published.
    where("items.published_at > ?", (DateTime.now - n.days)).
    where("comments_count > 0").
    order("comments_count DESC").
    includes(:attachments).
    limit(lim)
  end

  # Some Basic Scopes for finder chaining
  def self.last_item
    published.order("updated_at DESC").first
  end
  def self.published
    where("published_at < ?", DateTime.now)
  end
  def self.not_draft
    where(draft: false)
  end
  def self.draft
    where(draft: true)
  end

  # Only show items in the past 2 days in sitemaps
  def self.for_sitemap(lim=100)
    published.
    where("published_at > ?", DateTime.now-(48.hours)).
    not_draft.
    order("published_at DESC").
    limit(lim)
  end

  # Returns the top sticky item
  # Used on the Front End, joining attachments
  def self.top_sticky
    published.
    where(draft: false, sticky: true).
    order("published_at DESC").
    includes(:attachments).
    first
  end

  # Returns top Highlight Items
  # Used on the Front End, joining attachments
  def self.highlights(limit=6,offset=0)
    published.
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
    where(draft: false).
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
    # Use Resque for SOLR indexing
    def resque_solr_update
      Resque.enqueue(SolrUpdate, self.class.to_s, id)
    end
    def resque_solr_remove
      Resque.enqueue(SolrRemove, self.class.to_s, id)
    end

end
