require 'spec_helper'

describe Subscription do

  describe "Valitidy" do
    it "should_not be valid" do
      subscription = Subscription.new
      expect(subscription).not_to be_valid
    end
    it "should allow item_id with user_id" do
      subscription = Subscription.new
      subscription.item_id = 1
      subscription.email = nil
      subscription.user_id = 1
      expect(subscription).to be_valid
    end
    it "should allow email" do
      subscription = Subscription.new
      subscription.email = 'joe@doe.com'
      expect(subscription).to be_valid
    end
    it "should require email or user_id if it's admin" do
      subscription = Subscription.new
      subscription.admin = true
      expect(subscription).not_to be_valid
    end
    it "should allow admin if email is present" do
      subscription = Subscription.new
      subscription.admin = true
      subscription.email = 'joe@doe.com'
      expect(subscription).to be_valid
    end
    it "should not allow admin if only user_id is present" do
      subscription = Subscription.new
      subscription.admin = true
      subscription.user_id = 1
      expect(subscription).not_to be_valid
    end
    it "should allow admin only if email is present" do
      subscription = Subscription.new
      subscription.admin = true
      subscription.email = "joe@doe.com"
      expect(subscription).to be_valid
    end
  end
end
