class Query < ActiveRecord::Base
  serialize :raw_data, Hash
  belongs_to :item
  belongs_to :user

  def self.store(options={})
    Rails.logger.debug("Saving Query")
    query = self.new
    query.keyword  = options[:query]    if options[:query]
    query.locale   = options[:locale]   if options[:locale]
    query.user_id  = options[:user_id]  if options[:user_id]
    query.raw_data = options[:raw_data] if options[:raw_data]
    query.save
    true
  end

end
