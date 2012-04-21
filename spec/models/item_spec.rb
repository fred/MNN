require 'spec_helper'

describe Item do
  include NumericMatchers
  describe "A Simple Item" do 
    before(:each) do
      @item = Factory(:item)
    end
    it "should be valid" do
      @item.should be_valid
    end
    it "should require a category" do
      @item.category_id = nil
      @item.should_not be_valid
    end
    it "should require a title" do
      @item.title = nil
      @item.should_not be_valid
    end
    it "should require a body" do
      @item.body = nil
      @item.should_not be_valid
    end
    it "should require a published_at" do
      @item.published_at = nil
      @item.should_not be_valid
    end
    it "should not require a body if it is a youtube video" do
      @item.youtube_id = "a1b2c3d4e5"
      @item.body = nil
      @item.should be_valid
    end
    it "should not require abstract" do
      @item.abstract = nil
      @item.should be_valid
    end
    it "should not require user_id" do
      @item.user_id = nil
      @item.should be_valid
    end
    it "should delete an Item" do
      lambda {@item.destroy}.should_not raise_error
    end
    it "should allow to edit item" do
      @item.title = "A New item..."
      lambda {@item.save}.should_not raise_error
    end
  end
  describe "Editing an a Dirty Item" do
    before(:each) do
      @item = Factory(:item, :title => "Old Title")
    end
    it "should not allow to update a dirty item" do
      @outdated_item = Item.find(@item.id)
      @outdated_item.title = "Added a new title"
      @outdated_item.save
      @item.should_not be_valid
      # lambda {@item.save}.should raise_error
    end
  end
  
  describe "Creating Item with Subscription" do
    before(:each) do
      @item = Factory(:item, :draft => false, :send_emails => "1")
    end
    it "should create an EmailDelivery resource" do
      @item.email_deliveries.should_not eq([])
      @item.email_deliveries.last.should eq(EmailDelivery.first)
    end
    it "should have only one EmailDelivery resource" do
      @item.email_deliveries.count.should eq(1)
    end
    it "should not re-create an EmailDelivery resource after saving" do
      @item.draft = false
      @item.save
      @item.email_deliveries.count.should eq(1)
    end
    it "should have send_at date" do
      @item.email_deliveries.first.send_at.should_not eq(nil)
    end
    it "should have send_at queue time greater then publication date" do
      @item.email_deliveries.first.send_at.to_i.should greater_than(@item.published_at.to_i)
    end
    
  end
  
  describe "Creating Draft Item without Subscription" do
    before(:each) do
      @item = Factory(:item, :draft => true)
    end
    it "should not create an EmailDelivery resource" do
      @item.email_deliveries.should eq([])
      @item.email_deliveries.count.should eq(0)
    end
    it "should re-create an EmailDelivery resource after saving" do
      @item.draft = false
      @item.send_emails = "1"
      @item.save
      @item.email_deliveries.count.should eq(1)
    end
  end


  describe "Creating Non-Draft Item without Subscription" do
    before(:each) do
      @item = Factory(:item, :draft => true, :send_emails => "1")
    end
    it "should not create an EmailDelivery resource" do
      @item.email_deliveries.should eq([])
      @item.email_deliveries.count.should eq(0)
    end
    it "should re-create an EmailDelivery resource after saving" do
      @item.draft = false
      @item.save
      @item.email_deliveries.count.should eq(1)
    end
  end



  describe "Creating Item with future publication with Social Shares" do
    before(:each) do
      @item = Factory(:item, :published_at => Time.now+600, :share_twitter => "1")
    end
    it "should create a share twitter model with future enqueue_at date" do
      @item.twitter_shares.last.enqueue_at.to_i.should greater_than(@item.published_at.to_i)
    end
    it "should create the share twitter model with processed_at nil" do
      @share = @item.twitter_shares.last
      @share.processed_at.should eq(nil)
    end
  end


  describe "Creating Item with Social Shares" do
    before(:each) do
      @item = Factory(:item, :share_twitter => "1")
    end
    it "should create a share twitter model" do
      @item.twitter_shares.should_not eq([])
      @item.twitter_shares.last.should eq(TwitterShare.first)
    end
    it "should create the share twitter model with processed_at nil" do
      @share = @item.twitter_shares.last
      @share.processed_at.should eq(nil)
    end
  end
  
  describe "Creating Item without Social Shares" do
    before(:each) do
      @item = Factory(:item, :share_twitter => "0")
    end
    it "should not create a share twitter model" do
      @item.twitter_shares.should eq([])
      @item.twitter_shares.count.should eq(0)
    end
  end
  
  describe "Updating an Item with Social Shares" do
    before(:each) do
      @item = Factory(:item)
    end
    it "should not have a twitter share by default" do
      @item.twitter_shares.should eq([])
    end
    it "should create a share twitter after update if share_twitter = 1" do
      @item.share_twitter = 1
      @item.save
      @new_item = Item.find(@item.id)
      @new_item.twitter_shares.should_not eq([])
      @new_item.twitter_shares.last.should eq(TwitterShare.first)
    end
    it "should create a share twitter after update if share_twitter = true" do
      @item.share_twitter = true
      @item.save
      @new_item = Item.find(@item.id)
      @new_item.twitter_shares.should_not eq([])
      @new_item.twitter_shares.last.should eq(TwitterShare.first)
      @new_item.twitter_shares.count.should eq(1)
    end
    it "should not create a share twitter after update if share_twitter = false" do
      @item.share_twitter = false
      @item.save
      @new_item = Item.find(@item.id)
      @new_item.twitter_shares.should eq([])
    end
    it "should not create a share twitter after update if share_twitter = 0" do
      @item.share_twitter = 0
      @item.save
      @new_item = Item.find(@item.id)
      @new_item.twitter_shares.should eq([])
    end
  end
  
  describe "Updating an Item with already Social Shares" do
    before(:each) do
      @item = Factory(:item, :share_twitter => "1")
    end
    it "should not create a new share twitter it item already has one" do
      @item = Item.first
      @item.share_twitter = 1
      @item.save
      @item.twitter_shares.count.should eq(1)
    end
  end
  
  describe "Updating an Editing Item with SOLR enabled" do
    include EnableSunspot
    include ItemSpecHelper
    Sunspot.commit
    before(:each) do
      @item = Factory(:item)
    end
    it "should create an item" do
      lambda {Item.create(valid_item_attributes)}.should_not raise_error
    end
    it "should allow to edit an Item" do
      @item.title = "A New item..."
      lambda {@item.save}.should_not raise_error
    end
    it "should delete an Item" do
      lambda {@item.destroy}.should_not raise_error
    end
  end
  
end