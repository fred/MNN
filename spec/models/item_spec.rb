require 'spec_helper'

describe Item do
  include NumericMatchers

  describe "Valitidy" do
    before(:each) do
      @item = FactoryGirl.create(:item)
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
    it "should require abstract" do
      @item.abstract = nil
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
    it "should have ItemStat" do
      @item.item_stat.should_not be(nil)
      @item.item_stat.should be_an_instance_of ItemStat
    end
  end
  describe "Instance Methods" do
    before(:each) do
      @item = FactoryGirl.create(:item)
    end
    it "should respond to should_generate_new_friendly_id?" do
      @item.should respond_to(:should_generate_new_friendly_id?)
    end
    it "should respond to set_custom_slug" do
      @item.should respond_to(:set_custom_slug)
    end
    it "should respond to custom_slug" do
      @item.should respond_to(:custom_slug)
    end
    it "should respond to clear_bad_characters" do
      @item.should respond_to(:clear_bad_characters)
    end
    it "should respond to email_delivery_sent?" do
      @item.should respond_to(:email_delivery_sent?)
    end
    it "should respond to email_delivery_queued?" do
      @item.should respond_to(:email_delivery_queued?)
    end
    it "should respond to email_delivery_queued_at" do
      @item.should respond_to(:email_delivery_queued_at)
    end
    it "should respond to send_email_deliveries" do
      @item.should respond_to(:send_email_deliveries)
    end
    it "should respond to posted_to_twitter?" do
      @item.should respond_to(:posted_to_twitter?)
    end
    it "should respond to create_twitter_share" do
      @item.should respond_to(:create_twitter_share)
    end
    it "should respond to twitter_status" do
      @item.should respond_to(:twitter_status)
    end
    it "should respond to sitemap_refresh" do
      @item.should respond_to(:sitemap_refresh)
    end
    it "should respond to enqueue_time" do
      @item.should respond_to(:enqueue_time)
    end
    it "should respond to record_freshness" do
      @item.should respond_to(:record_freshness)
    end
    it "should respond to record_freshness_by_version" do
      @item.should respond_to(:record_freshness_by_version)
    end
    it "should respond to main_image" do
      @item.should respond_to(:main_image)
    end
    it "should respond to main_image_cache_key" do
      @item.should respond_to(:main_image_cache_key)
    end
    it "should respond to comment_cache_key" do
      @item.should respond_to(:comment_cache_key)
    end
    it "should respond to has_image?" do
      @item.should respond_to(:has_image?)
    end
    it "should respond to cache_key_full" do
      @item.should respond_to(:cache_key_full)
    end
    it "should respond to tag_list" do
      @item.should respond_to(:tag_list)
    end
    it "should respond to build_stat" do
      @item.should respond_to(:build_stat)
    end
    it "should respond to set_status_code" do
      @item.should respond_to(:set_status_code)
    end
    it "should respond to admin_permalink" do
      @item.should respond_to(:admin_permalink)
    end
    it "should respond to published?" do
      @item.should respond_to(:published?)
    end
    it "should respond to language_title_short" do
      @item.should respond_to(:language_title_short)
    end
    it "should respond to category_title" do
      @item.should respond_to(:category_title)
    end
    it "should respond to language_title" do
      @item.should respond_to(:language_title)
    end
    it "should respond to user_title" do
      @item.should respond_to(:user_title)
    end
    it "should respond to user_email" do
      @item.should respond_to(:user_email)
    end
    it "should respond to keywords_list" do
      @item.should respond_to(:keywords_list)
    end
    it "should respond to meta_keywords" do
      @item.should respond_to(:meta_keywords)
    end
    it "should respond to keyword_for_solr" do
      @item.should respond_to(:keyword_for_solr)
    end
  end


  describe "Updating Items with undesirable HTML Codes" do
    before(:each) do
      @item = FactoryGirl.create(:item, body: "&lsquo; An &rsquo; Item &ldquo; and &rdquo; &nbsp;")
    end
    it "should not allow to Left/Right Single/Double Quotes" do
      # @item.body.should eq("&#39; An &#39; Item &#34; and &#34;  ")
      @item.body.should eq("\' An \' Item \" and \"  ")
    end
    it "should replace [Left Single Curly Quotes] with [normal single quote]" do
      @item.body = "Item &lsquo;"
      @item.save
      # @item.body.should eq("Item &#39;")
      @item.body.should eq("Item \'")
    end
    it "should replace [Left Double Curly Quotes] with [normal double quotes]" do
      @item.body = "Item &ldquo;"
      @item.save
      # @item.body.should eq("Item &#34;")
      @item.body.should eq("Item \"")
    end
    it "should replace [Right Single Curly Quotes] with [normal single quote]" do
      @item.body = "Item &rsquo;"
      @item.save
      # @item.body.should eq("Item &#39;")
      @item.body.should eq("Item \'")
    end
    it "should replace [Right Double Curly Quotes] with [normal double quotes]" do
      @item.body = "Item &rdquo;"
      @item.save
      # @item.body.should eq("Item &#34;")
      @item.body.should eq("Item \"")
    end
    it "should replace &nbsp; with normal spaces" do
      @item.body = "The&nbsp;Item"
      @item.save
      @item.body.should eq("The Item")
    end
    it "should replace [en dash &ndash;] with [minus sign]" do
      @item.body = "The&ndash;Item"
      @item.save
      # @item.body.should eq("The&#45;Item")
      @item.body.should eq("The-Item")
    end
    it "should replace [em dash &mdash;] with [minus sign]" do
      @item.body = "The&mdash;Item"
      @item.save
      # @item.body.should eq("The&#45;Item")
      @item.body.should eq("The-Item")
    end
    it "should replace [acute accent with no letter] with [single quote]" do
      @item.body = "The&#180;Item"
      @item.save
      # @item.body.should eq("The&#39;Item")
      @item.body.should eq("The\'Item")
      @item.body.should eq("The'Item")
    end
    it "should replace [grave accent/reversed apostrophe with no letter] with [single quote]" do
      @item.body = "The&#96;Item"
      @item.save
      # @item.body.should eq("The&#39;Item")
      @item.body.should eq("The\'Item")
      @item.body.should eq("The'Item")
    end
    it "should replace [hellip] with [...]" do
      @item.body = "The&hellip;Item"
      @item.save
      @item.body.should eq("The...Item")
    end
  end

  describe "Editing an a Dirty Item" do
    before(:each) do
      @item = FactoryGirl.create(:item, title: "Old Title")
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
      @item = FactoryGirl.create(:item, draft: false, send_emails: "1")
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
    it "should not yet have sent the email" do
      @item.email_delivery_sent?.should eq(false)
    end
  end

  describe "Creating Draft Item without Subscription" do
    before(:each) do
      @item = FactoryGirl.create(:item, draft: true)
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
    it "should says it already sent the email" do
      @item.email_delivery_sent?.should eq(false)
    end
  end


  describe "Creating Non-Draft Item without Subscription" do
    before(:each) do
      @item = FactoryGirl.create(:item, draft: true, send_emails: "1")
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
    it "should have already sent the email" do
      @item.email_delivery_sent?.should eq(false)
    end
    it "should enqueue the email delivery" do
      @item.email_delivery_queued?.should eq(false)
    end
  end

  describe "Creating Item with future publication should enqueue the emails" do
    before(:each) do
      @item = FactoryGirl.create(:item, published_at: Time.now+600, send_emails: "1")
    end
    it "should enqueue the email delivery" do
      @item.email_delivery_queued?.should eq(true)
    end
    it "should not send the email yet" do
      @item.email_delivery_sent?.should eq(false)
    end
  end

  describe "Creating Item with future publication with Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item, published_at: Time.now+600, share_twitter: "1", send_emails: "1")
    end
    it "should create a share twitter model with future enqueue_at date" do
      @item.twitter_shares.last.enqueue_at.to_i.should greater_than(@item.published_at.to_i)
    end
    it "should create the share twitter model with processed_at nil" do
      @share = @item.twitter_shares.last
      @share.processed_at.should eq(nil)
    end
    it "should enqueue the email delivery" do
      @item.email_delivery_queued?.should eq(true)
    end
  end


  describe "Creating Item with Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item, share_twitter: "1")
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
      @item = FactoryGirl.create(:item, share_twitter: "0")
    end
    it "should not create a share twitter model" do
      @item.twitter_shares.should eq([])
      @item.twitter_shares.count.should eq(0)
    end
  end

  describe "Updating an Item with Social Shares" do
    before(:each) do
      @item = FactoryGirl.create(:item)
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
      @item = FactoryGirl.create(:item, share_twitter: "1")
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
      @item = FactoryGirl.create(:item)
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
