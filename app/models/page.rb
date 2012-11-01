class Page < ActiveRecord::Base
  validates_presence_of :title, :body
  belongs_to :language
  belongs_to :user

  attr_accessor :updated_reason

  # Versioning System
  has_paper_trail meta: { tag: :updated_reason }

  # Permalink URLS
  extend FriendlyId
  friendly_id :title, use: :slugged

  def self.active
    where(active: true)
  end

  def self.member_only
    where(member_only: true)
  end
end
