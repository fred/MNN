class Vote < ActiveRecord::Base
  belongs_to :voteable, :polymorphic => true
  belongs_to :voter, :polymorphic => true
  attr_accessible :vote, :voter, :voteable

  # Comment out the line below to allow multiple votes per user.
  validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :voter_type, :voter_id]

  after_create  :touch_voteable
  after_destroy :touch_voteable

  # scope :for_voter, lambda { |*args| where(["voter_id = ? AND voter_type = ?", args.first.id, args.first.class.base_class.name]) }
  # scope :for_voteable, lambda { |*args| where(["voteable_id = ? AND voteable_type = ?", args.first.id, args.first.class.base_class.name]) }
  # scope :recent, lambda { |*args| where(["created_at > ?", (args.first || 2.weeks.ago)]) }

  def touch_voteable
    self.voteable.touch
  end

  def self.for_voter(*args)
    where(["voter_id = ? AND voter_type = ?", args.first.id, args.first.class.base_class.name])
  end

  def self.for_voteable(*args)
    where(["voteable_id = ? AND voteable_type = ?", args.first.id, args.first.class.base_class.name])
  end

  def self.recent(*args)
    where(["created_at > ?", (args.first || 2.weeks.ago)])
  end

  def self.descending
    order("created_at DESC")
  end

end
