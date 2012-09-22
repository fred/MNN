require 'spec_helper'

describe Item do
  include NumericMatchers
  include ItemSpecHelper

  describe "Creating Item with future publication with Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item, published_at: Time.now+600, share_facebook: "1", send_emails: "1")
    end
    it "should create a share facebook model with future enqueue_at date" do
      expect(@item.facebook_shares.last.enqueue_at.to_i).to greater_than(@item.published_at.to_i)
    end
    it "should create the share facebook model with processed_at nil" do
      @share = @item.facebook_shares.last
      expect(@share.processed_at).to eq(nil)
    end
    it "should enqueue the email delivery" do
      expect(@item.email_delivery_queued?).to eq(true)
    end
  end


  describe "Creating Item with Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item, share_facebook: "1")
    end
    it "should create a share facebook model" do
      expect(@item.facebook_shares).not_to eq([])
      expect(@item.facebook_shares.last).to eq(FacebookShare.first)
    end
    it "should create the share facebook model with processed_at nil" do
      @share = @item.facebook_shares.last
      expect(@share.processed_at).to eq(nil)
    end
  end

  describe "Creating Item without Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item, share_facebook: "0")
    end
    it "should not create a share facebook model" do
      expect(@item.facebook_shares).to eq([])
      expect(@item.facebook_shares.count).to eq(0)
    end
  end

  describe "Updating an Item with Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item)
    end
    it "should not have a facebook share by default" do
      expect(@item.facebook_shares).to eq([])
    end
    it "should create a share facebook after update if share_facebook = 1" do
      @item.share_facebook = 1
      @item.save
      @new_item = Item.find(@item.id)
      expect(@new_item.facebook_shares).not_to eq([])
      expect(@new_item.facebook_shares.last).to eq(FacebookShare.first)
    end
    it "should create a share facebook after update if share_facebook = true" do
      @item.share_facebook = true
      @item.save
      @new_item = Item.find(@item.id)
      expect(@new_item.facebook_shares).not_to eq([])
      expect(@new_item.facebook_shares.last).to eq(FacebookShare.first)
      expect(@new_item.facebook_shares.count).to eq(1)
    end
    it "should not create a share facebook after update if share_facebook = false" do
      @item.share_facebook = false
      @item.save
      @new_item = Item.find(@item.id)
      expect(@new_item.facebook_shares).to eq([])
    end
    it "should not create a share facebook after update if share_facebook = 0" do
      @item.share_facebook = 0
      @item.save
      @new_item = Item.find(@item.id)
      expect(@new_item.facebook_shares).to eq([])
    end
  end

  describe "Updating an Item with already Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item, share_facebook: "1")
    end
    it "should not create a new share facebook it item already has one" do
      @item = Item.first
      @item.share_facebook = 1
      @item.save
      expect(@item.facebook_shares.count).to eq(1)
    end
  end

end