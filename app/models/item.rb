class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models

  DEFAULT_LOCALE = 'en'

  acts_as_voteable

  attr_protected :user_id, :slug, :updated_by, :deleted_at, :updating_user_id

  attr_accessor :updated_reason, :share_facebook, :share_twitter, :send_emails, :existing_attachment_id, :updating_user_id

  # Versioning System
  has_paper_trail meta: { tag: :updated_reason }, :ignore => [:updated_at, :last_commented_at, :comments_count]

  # Comment System
  opinio_subjectum conditions: {approved: true}, include: :owner

  # Permalink URLS
  extend FriendlyId
  friendly_id :title,   use: :slugged

  # Relationships
  belongs_to :user,       inverse_of: :items,  counter_cache: true
  belongs_to :category,   inverse_of: :items
  belongs_to :language,   inverse_of: :items
  has_one    :item_stat,  inverse_of: :item

  has_many  :attachments,           as: :attachable
  has_many  :sitemap_jobs,          as: :processable
  has_many  :feed_jobs,             as: :processable
  has_many  :twitter_shares,        dependent: :destroy
  has_many  :facebook_shares,       dependent: :destroy
  has_many  :email_deliveries,      dependent: :destroy
  has_many  :comment_subscriptions, dependent: :destroy
  has_many  :search_queries
  has_many  :page_views

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

  validate :check_security, on: :update

  # Filter hooks
  before_save   :clear_bad_characters
  before_save   :dup_existing_attachment
  before_save   :update_custom_slug
  before_update :set_status_code
  before_create :build_stat
  after_create  :set_custom_slug

  after_save   :process_sitemap_job
  after_save   :create_twitter_share
  after_save   :create_facebook_share
  after_save   :send_email_deliveries


  ################
  ####  SOLR  ####
  ################
  # searchable auto_index: false, auto_remove: false do # if using QUEUE
  searchable do
    text :title,          boost: 2.4
    text :abstract,       boost: 1.6
    text :keywords,       boost: 4.0
    text :author_name,    boost: 1.6
    text :category_title, boost: 1.8
    text :author_email
    text :article_source
    text :source_url
    text :body
    text :youtube_id
    integer :id, trie: true
    integer :category_id, references: Category, trie: true
    integer :language_id, references: Language, trie: true
    integer :user_id,     references: User, trie: true
    boolean :draft
    boolean :featured
    boolean :sticky
    time :updated_at, trie: true
    time :published_at, trie: true
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

  def recent_page_views(lim=10)
    page_views.order("id DESC").limit(lim)
  end

  def last_modified
    if last_commented_at.present? && (last_commented_at > last_updated_version)
      last_commented_at
    else
      last_updated_version
    end
  end

  def last_updated_version
    if versions.empty?
      self.updated_at
    else
      versions.last.created_at
    end
  end

  def updated_after_published?
    !versions.empty? && versions.last.created_at > (published_at + 1.hour)
  end

  def check_security
    unless can_update?
      Rails.logger.info("  Security Protection: Author tried to update published item.")
      errors.add(:item, " - Sorry, you can't update a live article. Please contact an editor.")
    end
  end

  def can_update?
    if updating_user_id && (@updating_user = User.find(updating_user_id))
      self.draft? or (!self.draft? && @updating_user.has_any_role?(:admin,:editor))
    else
      true
    end
  end

  def after_initialize
    self.draft ||= true
    self.published_at ||= Time.zone.now  # will set the default value only if it's nil
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
    # new_record?
    false
  end

  def update_custom_slug
    self.slug = custom_slug
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
    if body.present?
      body.to_s.gsub!("&lsquo;", "\'")
      body.to_s.gsub!("&rsquo;", "\'")
      body.to_s.gsub!("&ldquo;", "\"")
      body.to_s.gsub!("&rdquo;", "\"")
      body.to_s.gsub!("&ndash;", "-")
      body.to_s.gsub!("&mdash;", "-")
      body.to_s.gsub!("&#180;", "\'")
      body.to_s.gsub!("&#96;", "\'")
      body.to_s.gsub!("&nbsp;", " ")
      body.to_s.gsub!("&hellip;", "...")
    end
    true
  end



  ##############
  #### JOBS ####
  ##############

  # Random time between 150-180 seconds
  def enqueue_time
    if published?
      Time.now + 120 + Kernel.rand(29)
    else
      self.published_at + 120 + Kernel.rand(29)
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

  # Creates the Facebook sharing JOB
  # checks the item publication date and set the time to send the twitter share
  # Set Posting tim to be 3 minutes after the publication_date of item.
  def create_facebook_share
    if !self.draft && (self.share_facebook.to_s=="1" or self.share_facebook==true) && self.facebook_shares.empty?
      Rails.logger.info("  Facebook: Creating Facebook Share for item: #{self.id}")
      self.facebook_shares << FacebookShare.new(enqueue_at: self.enqueue_time, status: 'queued')
    end
    true
  end

  def twitter_status
    url  = title.truncate((110 - hashtags.to_s[0..39].size), separator: ' ')
    url += " "
    url += url_for(item_path(self, host: "worldmathaba.net", only_path: false, protocol: 'http'))
    url += " #{hashtags.to_s[0..39]}" if hashtags.present?
    return url
  end

  # Queue up sitemap generation after 3 minutes
  def process_sitemap_job
    if !self.draft && self.sitemap_jobs.empty?
      Rails.logger.info("  Sitemap: Scheduling sitemap generation for item: #{self.id}")
      self.sitemap_jobs << SitemapJob.new(enqueue_at: enqueue_time)
    end
  end

  def youtube_mobile_height
    '320'
  end
  def youtube_mobile_width
    '480'
  end

  def youtube_height
    if youtube_res.present?
      youtube_res.split("x").first
    else
      '390'
    end
  end
  def youtube_width
    if youtube_res.present?
      youtube_res.split("x").last
    else
      '640'
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
    if self.comments_count > 0 && self.updated_at
      self.updated_at.to_s(:number)
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

  def etag_key
    self.id + self.updated_at
  end

  def etag
    Digest::MD5.hexdigest(etag_key.to_s)
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

  def author
    if original
      user_title
    else
      author_name
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
    Item.solr_search(include: [:attachments, :user]) do
      fulltext self.keyword_for_solr
      if self.language_id
        with(:language_id, self.language_id)
      end
      without(:id, self.id)
      with(:draft, false)
      with(:published_at).less_than Time.now
      adjust_solr_params do |params|
        params[:boost] = "recip(ms(NOW/DAY,published_at_dt),3.16e-10,1,1)"
        params[:defType] = :edismax
      end
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

  def approved_comments
    comments.where(marked_spam: false, suspicious: false, approved: true)
  end

  ####################
  ### CLASS METHODS
  ####################

  def self.draft
    where(draft: true)
  end
  def self.not_draft
    where(draft: false)
  end
  def self.original
    where(original: true)
  end
  def self.not_original
    where(original: false)
  end
  def self.highlight
    where(featured: true)
  end
  def self.not_highlight
    where(featured: false)
  end
  def self.sticky
    where(sticky: true)
  end
  def self.not_sticky
    where(sticky: false)
  end
  def self.with_comments
    where("comments_count > 0")
  end

  def self.from_youtube
    where("youtube_id is not NULL").
    where(youtube_vid: true)
  end

  def self.default_language
    Language.where(locale: self.default_locale).first
  end

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
    select("id, updated_at, last_commented_at, draft, published_at").not_draft.published.order("updated_at DESC").first
  end

  def self.reduced
    select(min_fields)
  end

  def self.min_fields
    a = %W{items.id title slug abstract published_at updated_at last_commented_at author_name
      sticky featured original draft language_id category_id user_id comments_count
      youtube_img youtube_id youtube_vid protected
    }
    a.join(", items.")
  end

  # Returns the most popular Items in the last N days
  def self.popular(lim=5, days=31)
    reduced.
    not_draft.
    published.
    joins(:item_stat).
    where("items.published_at > ?", (DateTime.now - days.days)).
    order("item_stats.views_counter DESC").
    limit(lim)
  end

  # Returns the most Commented Items
  def self.recently_commented(lim=5)
    reduced.
    not_draft.
    published.
    where("items.comments_count > 0").
    where("items.last_commented_at is NOT NULL").
    order("items.last_commented_at DESC").
    limit(lim)
  end

  # Returns the most Commented Items in the last N days
  def self.most_commented(lim=5, n=30)
    reduced.
    not_draft.
    published.
    where("items.published_at > ?", (DateTime.now - n.days)).
    where("comments_count > 0").
    order("comments_count DESC").
    limit(lim)
  end

  def self.news_for_sitemap(lim=100, hrs=96)
    self.for_sitemap(lim,hrs).where(original: true)
  end

  # Only show items in the past 2 days in sitemaps
  def self.for_sitemap(lim=100, hrs=48)
    reduced.
    not_draft.
    published.
    where("published_at > ?", DateTime.now-(hrs.hours)).
    order("published_at DESC").
    limit(lim)
  end

  def self.localized
    language = Language.where(locale: default_locale).first
    if language
      where("language_id = ?", language.id)
    else
      where('')
    end
  end

  def self.for_language(language_id)
    where("language_id = ?", language_id)
  end

  # Returns the top sticky item
  # Used on the Front End, joining attachments
  def self.top_sticky
    reduced.
    where(draft: false, sticky: true).
    published.
    localized.
    order("published_at DESC").
    first
  end

  # Returns top Highlight Items
  # Used on the Front End, joining attachments
  def self.highlights(limit=6,offset=0)
    reduced.
    highlight.
    not_draft.
    not_sticky.
    published.
    localized.
    order("published_at DESC").
    limit(limit).
    offset(offset)
  end

  # Returns the last 10 approved items (not draft anymore)
  # Used on the dashboard
  def self.recent_updated(limit=10)
    not_draft.
    published.
    where("updated_at > created_at").
    order("updated_at DESC").
    limit(limit)
  end

  # Returns the last 10 approved items (not draft anymore)
  # Used on the Admin Dashboard
  def self.recent(limit=10)
    not_draft.
    published.
    order("id DESC").
    limit(limit)
  end

  # Returns the last 10 draft items
  # Used on the Admin Dashboard
  def self.recent_drafts(limit=10)
    draft.
    reduced.
    order("updated_at DESC").
    limit(limit)
  end

  # Only for slugs that match ^[0-9]-[a-zA-Z]
  def self.find_from_slug(slug)
    if slug.match("^[0-9]+-")
      id = slug.match("^[0-9]+-").to_s.gsub('-','')
      s = where(id: id)
    elsif slug.match("^[a-zA-Z]") && \
      s = where("slug like ?", "%" + slug.split("&").first + "%")
    else
      s = where(id: slug.to_i)
    end
    s
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

  def self.solr_search_term(term,page=1,per_page=100)
    test_search = Item.solr_search do
      fulltext term
      paginate page: page, per_page: per_page
    end
    test_search
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

