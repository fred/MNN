class Query < ActiveRecord::Base

  serialize :raw_data, Hash
  belongs_to :item
  belongs_to :user

  ################
  ####  SOLR  ####
  ################
  searchable do
    text :keyword
    text :raw_data
    text :short_user_agent
  end

  def self.store(options={})
    Rails.logger.debug("Saving Query")
    query = self.new
    query.keyword  = options[:keyword]  if options[:keyword].present?
    query.locale   = options[:locale]   if options[:locale].present?
    query.user_id  = options[:user_id]  if options[:user_id].present?
    query.raw_data = options[:raw_data] if options[:raw_data].present?
    query.item_id  = options[:item_id]  if options[:item_id].present?
    query.save
    true
  end

  def self.popular(lang='en')
    select("keyword, locale, count(keyword)").
    where(locale: lang.to_s).
    group("keyword,locale").
    order("count DESC")
  end

  def short_user_agent
    if raw_data[:user_agent].present?
      tmp = raw_data[:user_agent].split
      tmp.reverse[0..2].join(" ")
    else
      raw_data
    end
  end

  def user_agent
    raw_data[:user_agent]
  end
  def user_ip
    raw_data[:ip]
  end
  def referrer
    raw_data[:referrer]
  end

  def self.cleanup(string)
    search = self.solr_search { fulltext string; paginate page: 1, per_page: 1000 }
    search.results.each {|t| t.destroy}
    Sunspot.commit
    return search.total
  end

end
