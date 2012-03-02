require 'spec_helper'

describe Item do  
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
  
  describe "Creating Item with Social Shares" do
    before(:each) do
      @item = Factory(:item, :share_twitter => true)
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
  
  describe "Updating an Item with Social Shares" do
    before(:each) do
      @item = Factory(:item)
    end
    it "should not have a twitter share by default" do
      @item.twitter_shares.should eq([])
    end
    it "should create a share twitter after update" do
      @item.share_twitter = true
      @item.save
      @new_item = Item.find(@item.id)
      @new_item.twitter_shares.should_not eq([])
      @new_item.twitter_shares.last.should eq(TwitterShare.first)
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