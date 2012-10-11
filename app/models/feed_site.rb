class FeedSite < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  attr_accessor :feed

  require 'timeout'
  
  belongs_to :category
  belongs_to :user
  
  has_many :feed_entries, order: "published DESC, id DESC", dependent: :destroy
  
  before_save :get_details
  after_save :clean_older_feeds
  
  FEED_TYPES = [ 
    {:id => 1, :name => "atom"}, 
    {:id => 2, :name => "atom_feedburner"},
    {:id => 3, :name => "rss"},
    {:id => 4, :name => "itunes_rss"}
  ]

  def self.last_cache_key
    t = order("updated_at DESC").first
    if t
      t.full_cache_key
    else
      "no-feeds"
    end
  end

  def full_cache_key
    "#{id}/#{updated_at.to_s(:number)}"
  end

  def summary_total_size
    @bytes = 0
    self.feed_entries.each do |t|
      @bytes += t.summary.to_s.size
    end
    @bytes
  end

  def content_total_size
    @bytes = 0
    self.feed_entries.each do |t|
      @bytes += t.content.to_s.size
    end
    @bytes
  end

  # Clear older feed_entries leaving only the 50 newest
  def clean_older_feeds
    total = self.feed_entries.count
    FeedEntry.where(feed_site_id: self.id).order("id ASC").limit(total-50).destroy_all if (total > 50)
  end

  def category_name
    category.title if category
  end

  def force_refresh
    self.etag = nil
    self.last_modified  = Time.now - 7.days
    self.feed_entries.destroy_all
    self.save
  end

  def get_details
    @entries_count = 0
    feed = Feedzirra::Feed.fetch_and_parse(self.url.to_s)
    # sometimes we get 404 errors on feeds (Fixnum)
    if (feed.nil? or (feed.is_a? Fixnum) or feed.class.to_s.match("Feedzirra").nil?)
      Rails.logger.info "[FEED] *** Error: feed:#{feed}, class:#{feed.class}"
      return false
    end
    self.title = feed.title.to_s if self.title.to_s.blank?
    self.description = feed.class.to_s if self.description.to_s.blank?
    self.site_url = feed.url.to_s

    # Start with 7 days articles
    self.last_modified  = Time.now - 7.days unless self.last_modified.present?

    # Skip 5 minutes, might loose a few feeds.
    # will happen rarelly, but helps to avoid dupplicate entries 
    fetched_etag = feed.etag if feed.etag
    Rails.logger.info "[FEED] Checking fetched etag: #{fetched_etag}"
    if feed.last_modified && (feed.last_modified.is_a? Time)
      feed_last_modified = feed.last_modified 
    elsif feed.last_modified && (feed.last_modified.is_a? String)
      feed_last_modified = Time.parse(feed.last_modified) 
    else
      feed_last_modified = Time.now
    end
    
    if feed_entries.empty? or (fetched_etag && (fetched_etag != etag)) or (feed_last_modified.to_i > (last_modified.to_i+60))
      feed.entries[0..30].each do |t|
        # Some stupid RSS feeds don't put last_modified. If no last_modified then skip.
        if t.last_modified && (t.last_modified.is_a? Time)
          entry_last_modified = t.last_modified 
        elsif t.last_modified && (t.last_modified.is_a? String)
          entry_last_modified = Time.parse(t.last_modified)
        else
          entry_last_modified = nil
        end
        # allow 60 seconds delay for feed saving, to avoid dupplicates, might loose a feed entry in rare cases.
        if feed_entries.empty? or (entry_last_modified && (entry_last_modified.to_i > (last_modified.to_i+60))) or new_record?
          fi = FeedEntry.new
          fi.title = t.title.to_s[0..250]
          fi.url = t.url[0..250]
          fi.url = fi.url[0..250] unless (!t.url && fi.url.to_s.match(/^(http|https)/))
          if fi.url.match(/\?/)
            fi.url = fi.url.to_s.split("?").first.to_s[0..250]
          end
          fi.author = t.author.to_s[0..250]
          fi.summary = t.summary
          fi.content = t.content
          fi.published = last_modified
          unless self.feed_entries.where(title: fi.title).any?
            self.feed_entries << fi
            @entries_count += 1
            msg="[FEED] new: #{fi.title}"
            Rails.logger.info msg
          end
        end
      end
      msg = "[FEED] Added #{@entries_count} new items to #{feed.title}."
      Rails.logger.info msg
      self.last_modified = feed_last_modified
      self.etag = fetched_etag
    end
    true
  end

  def self.refresh_all(start=1)
    all_feeds = FeedSite.where(["id >= ?", start])
    all_feeds.each do |t|
      Rails.logger.info "Refreshing feed: #{t.id}..."
      # 1 minute timeout
      begin
        Timeout::timeout(60) {
          if t.save
            msg = "[FEED] Success for feed: #{t.id}"
          else
            msg = "[FEED] Cannot save feed: #{t.id}"
          end
        }
      rescue Timeout::Error
        msg = "[FEED] Timeout for feed #{t.id}"
      end
      Rails.logger.info msg
    end
  end

end
