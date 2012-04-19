class Subscription < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  # attr_accessible :title, :body
end
