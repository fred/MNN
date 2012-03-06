class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models
  
  attr_protected :user_id, :slug, :updated_by, :deleted_at
  
  attr_accessor :updated_reason, :share_twitter
  
  # Versioning System
  has_paper_trail :meta => { :tag  => :updated_reason }
  
  # Comment System
  opinio_subjectum
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  # Relationships
  belongs_to :user
  belongs_to :category
  belongs_to :language
  has_many :attachments, :as => :attachable
  has_one :item_stat
  has_many :twitter_shares, :dependent => :destroy
  
  has_and_belongs_to_many :tags, :join_table => "taggings", 
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"

  has_and_belongs_to_many :general_tags, :join_table => "taggings", 
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"

  has_and_belongs_to_many :region_tags, :join_table => "taggings",
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"

  has_and_belongs_to_many :country_tags, :join_table => "taggings",
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"

  # Nested Attributes
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => lambda { |t| t['image'].nil? }
  
  validates_presence_of :title, :category_id, :published_at
  validates_presence_of :body, :if => Proc.new { |item| item.youtube_id.blank? }
  
  # Filter hooks
  before_save   :create_twitter_share
  before_update :set_status_code
  before_create :build_stat
  
  # if Rails.env.production?
  # after_commit   :resque_solr_update
  # before_destroy :resque_solr_remove
  # end
  
  
  validate :record_freshness
  
  ################
  ####  SOLR  ####
  ################
  searchable do
    text :title, :boost => 2.4
    text :abstract, :boost => 1.6
    text :keywords, :boost => 5.0
    text :category_title, :boost => 1.8
    text :author_name, :boost => 2.2
    text :author_email
    text :article_source
    text :source_url
    text :body
    text :youtube_id
    integer :id
    integer :category_id, :references => Category
    integer :language_id, :references => Language
    integer :user_id,     :references => User
    boolean :draft
    boolean :featured
    time :updated_at
    time :published_at
    # boost { 3.0 if featured }
    text :tags do
      tags.map { |tag| tag.title }
    end
  end
  
  def posted_to_twitter?
    if !self.twitter_shares.empty? && self.twitter_shares.first.processed_at
      true
    else
      false
    end
  end
  
  def create_twitter_share
    if (self.share_twitter.to_s=="1" or self.share_twitter==true) && !self.draft && self.twitter_shares.empty?
      self.twitter_shares << TwitterShare.new
    end
  end
  
  def twitter_status
    url  = self.title.truncate(115)
    url += " "
    url += url_for(item_path(self, :host => "worldmathaba.net", :only_path => false, :protocol => 'http'))
    return url
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
  
  def has_image?
    if !self.attachments.empty? && self.attachments.first.image
      true
    else
      false
    end
  end
  
  def tag_list(join=", ")
    array = []
    self.tags.each do |t|
      array << t.title
    end
    array.join(join)
  end
  
  
  def build_stat
    self.item_stat = ItemStat.new(:views_counter => 0)
  end

  def after_initialize
    self.draft ||= true
    self.published_at ||= Time.zone.now  # will set the default value only if it's nil
    self.expires_on   ||= Time.zone.now+10.years
  end
  
  def self.last_item
    published.order("updated_at DESC").first
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
    !self.published_at.nil?
  end  
  
  def self.published
    where("published_at is not NULL")
  end
  def self.not_draft
    where(:draft => false)
  end
  def self.draft
    where(:draft => true)
  end
  
  # Highlights
  def self.highlights(limit=6,offset=0)
    published.
    where(:draft => false, :featured => true).
    order("published_at DESC").
    limit(limit).
    includes(:attachments).
    offset(offset).
    all
  end
  
  # Returns the last 10 approved items (not draft anymore)
  def self.recent_updated(limit=10)
    published.
    where(:draft => false).
    where("updated_at > created_at").
    order("updated_at DESC").
    limit(limit).
    all
  end
    
  # Returns the last 10 approved items (not draft anymore)
  def self.recent(limit=10)
    published.
    order("id DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 draft items
  def self.recent_drafts(limit=10)
    draft.
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 pending items (not draft anymore)
  def self.pending(limit=10)
    where(:published_at => nil).
    where(:draft => false).
    order("updated_at DESC").
    limit(limit).
    all
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
      ""
    end
  end
  def user_title
    if self.user && !self.user.name.empty?
      self.user.name
    elsif !self.author_name.empty?
      self.author_name
    else
      "mnn"
    end
  end
  def user_email
    if self.user && self.user.email
      self.user.email
    else
      "worldmathaba@gmail.com"
    end
  end
  
  # This builds the solr keyword for search articles
  def keyword_for_solr
    # @str = self.keywords.to_s.gsub(","," ")
    # @str += " "
    # @str += self.tag_list(" ")
    # @str
    self.keywords.to_s.gsub(","," ")
  end
  
  
  # Find Similar listings based on information only.
  def solr_similar(limit=6)
    # IF no bedrooms or bathrooms
    Item.solr_search do
      fulltext self.keyword_for_solr
      if self.language_id
        with(:language_id, self.language_id)
      end
      without(:id, self.id)
      with(:draft, false)
      paginate :page => 1, :per_page => limit
    end
  end
  
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
        :title => title,
        :published_at => time,
        :body => body,
        :author_name => author_name,
        :source_url => item_id,
        :draft => true,
        :featured => false,
        :user_id => user.id
      )
    end
  end
  
  
  
  protected
    # From https://gist.github.com/1282013
    # Use Resque for SOLR indexing
    def resque_solr_update
      Resque.enqueue(SolrUpdate, self, id)
    end
    def resque_solr_remove
      Resque.enqueue(SolrRemove, self, id)
    end

end
