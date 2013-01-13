class Subscription < ActiveRecord::Base
  has_paper_trail

  belongs_to :user
  belongs_to :item

  validate :check_admin
  validate :check_user

  def check_user
    unless (email.present? or user_id.present?)
      errors.add(:admin, " requires an email or user_id")
    end
  end

  def check_admin
    if admin && !email.present?
      errors.add(:admin, " requires an email")
    end
  end

  def self.for_admin
    where("email is not NULL").
    where(admin: true)
  end
end
