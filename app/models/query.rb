class Query < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore
  belongs_to :user

  def self.store(options={})
    Rails.logger.debug("Saving Query")
    query = self.new
    query.keyword  = options[:keyword]  if options[:keyword].present?
    query.locale   = options[:locale]   if options[:locale].present?
    query.user_id  = options[:user_id]  if options[:user_id].present?
    query.data     = options[:data]     if options[:data].present?
    query.item_id  = options[:item_id]  if options[:item_id].present?
    query.save if query.valid?
    true
  end

  def short_user_agent
    if data && data["user_agent"].present?
      tmp = data["user_agent"].split
      tmp.reverse[0..4].join(" ")
    else
      ""
    end
  end

  def user_agent
    data["user_agent"] if data && data["user_agent"].present?
  end

  def user_ip
    data["ip"] if data && data["ip"].present?
  end

  def referrer
    data["referrer"] if data && data["referrer"].present?
  end

end