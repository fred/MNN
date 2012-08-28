class Query < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  def self.store(options={})
    Rails.logger.debug("Saving Query")
    query = self.new
    query.keyword = options[:query]   if options[:query]
    query.locale  = options[:locale]  if options[:locale]
    query.user_id = options[:user_id] if options[:user_id]
    query.save
    true
  end

end
