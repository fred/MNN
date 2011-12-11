class Item < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  belongs_to :user
  has_many :attachments, :as => :attachable
  
  
end
