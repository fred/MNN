class Role < ActiveRecord::Base
  validates_presence_of :title
  has_and_belongs_to_many :users
end
