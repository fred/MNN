class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models

  attr_accessor :updated_reason
  
  # Versioning System
  has_paper_trail :meta => { :tag  => :updated_reason }
  
  # Comment System
  # opinio_subjectum
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  # Relationships
  belongs_to :user
  belongs_to :category
  belongs_to :language
  has_many :attachments, :as => :attachable
  has_many :item_stats

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
  
  validates_presence_of :title, :category_id, :body, :published_at
  
  # Filter hooks
  before_update :set_status_code
  
  
  ################
  ####  SOLR  ####
  ################
  searchable do
    text :title, :boost => 2.4
    text :abstract, :boost => 1.4
    text :body
    text :category_title, :boost => 2.2
    integer :category_id, :references => Category
    integer :language_id, :references => Language
    boolean :draft
    boolean :featured
    time :updated_at
    time :published_at
    boost { 3.0 if featured }
    text :tags do
      tags.map { |tag| tag.title }
    end
  end

  def after_initialize
    self.draft ||= true
    self.published_at ||= Time.now  # will set the default value only if it's nil
    self.expires_on   ||= Time.now+10.years
  end
  
  def self.last_item
    published.order("updated_at DESC").first
  end
  
  # Set to draft automatically upon creation
  def set_status_code
    if self.published_at && (self.published_at > Time.now)
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
    where(:draft => false).
    order("published_at DESC").
    limit(limit).
    offset(offset).
    all
  end
  
  # Returns the last 10 approved items (not draft anymore)
  def self.recent_updated(limit=10)
    published.
    where(:draft => false).
    order("updated_at DESC").
    limit(limit).
    all(:conditions => "updated_at > created_at")
  end
    
  # Returns the last 10 approved items (not draft anymore)
  def self.recent(limit=10)
    published.
    draft.
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
    published.
    where(:draft => false).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  
  def category_title
    if self.category
      self.category.title
    else
      "Uncategorized"
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
    
end
