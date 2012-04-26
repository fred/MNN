require 'spec_helper'

describe User do
  describe "A User" do 
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it "should be valid" do
      assert_equal true, @user.valid?
    end
    it "should require a email" do
      @user.email = nil
      assert_equal false, @user.valid?
    end
    it "should return false on is_admin?" do
      @user.is_admin?.should eq(false)
    end
    it "should allow to Upgrade user" do
      @user.upgrade = "1"
      @user.save
      @user.is_admin?.should eq(true)
    end
  end
  

  
  describe "Users with subscription" do
    before(:each) do
      @user = FactoryGirl.create(:user, :subscribe => "1")
    end
    it "should create a subscription model" do
      @user.subscriptions.should_not eq([])
      @user.subscriptions.last.should eq(Subscription.first)
    end
    it "should create a subscription with the user email" do
      @subscription = @user.subscriptions.last
      @subscription.email.should eq(@user.email)
    end
    it "should delete the user subscription when unsubscribed" do
      @user.subscribe = nil
      @user.unsubscribe = "1"
      @user.save
      @user.subscriptions.should eq([])
    end
    it "should delete the user subscription when unsubscribe_all" do
      @user.unsubscribe_all = "1"
      @user.subscribe = nil
      @user.save
      @user.subscriptions.should eq([])
      @user.subscriptions.count.should eq(0)
    end
    it "should update the user subscription email when saving user" do
      @user.email = "123456@new_email.com"
      @user.save
      @user.subscriptions.last.email.should eq(@user.email)
    end
  end
  
  describe "Users with unsubscribe or unsubscribe_all" do
    before(:each) do
      @user = FactoryGirl.create(:user, :unsubscribe => "1")
    end
    it "should not create a subscription" do
      @user.subscriptions.should eq([])
      @user.subscriptions.count.should eq(0)
    end
    it "should delete the user subscription when unsubscribe_all" do
      @user.unsubscribe_all = "1"
      @user.subscribe = nil
      @user.save
      @user.subscriptions.should eq([])
      @user.subscriptions.count.should eq(0)
    end
    it "should create the user subscription when subscribed" do
      @user.unsubscribe = nil
      @user.subscribe = "1"
      @user.save
      @user.subscriptions.should_not eq([])
    end
    it "should update the user email but not create subscription" do
      @user.email = "123456@new_email.com"
      @user.save
      @user.subscriptions.should eq([])
    end
  end
  
end
