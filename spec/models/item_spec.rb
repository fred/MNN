require 'spec_helper'

describe Item do
  include NumericMatchers
  include ItemSpecHelper

  describe "Valitidy" do
    let(:item) {
      FactoryGirl.create(:item)
    }
    it "should be valid" do
      expect(item).to be_valid
    end
    it "should require a category" do
      item.category_id = nil
      expect(item).not_to be_valid
    end
    it "should require a title" do
      item.title = nil
      expect(item).not_to be_valid
    end
    it "should require abstract" do
      item.abstract = nil
      expect(item).not_to be_valid
    end
    it "should require a body" do
      item.body = nil
      expect(item).not_to be_valid
    end
    it "should require a published_at" do
      item.published_at = nil
      expect(item).not_to be_valid
    end
    it "should not require a body if it is a youtube video" do
      item.youtube_id = "a1b2c3d4e5"
      item.body = nil
      expect(item).to be_valid
    end
    it "should not require user_id" do
      item.user_id = nil
      expect(item).to be_valid
    end
    it "should delete an Item" do
      expect(lambda {item.destroy}).not_to raise_error
    end
    it "should allow to edit item" do
      item.title = "A New item..."
      expect(lambda {item.save}).not_to raise_error
    end
    it "should have ItemStat" do
      expect(item.item_stat).not_to be(nil)
      expect(item.item_stat).to be_an_instance_of ItemStat
    end
    it 'should have proper enqueue_time time' do
      expect(item.enqueue_time).not_to be(nil)
      expect(item.enqueue_time).to be_an_instance_of(Time)
      expect(item.enqueue_time.to_i).to greater_than(item.published_at.to_i)
    end
  end
  describe "Instance Methods" do
    let(:item){
      stub_model(Item,
        title: "MyString",
        body: "MyString",
        category_id: 1,
        language_id: 1,
        user_id: 1
      )
    }
    it "should respond to should_generate_new_friendly_id?" do
      expect(item).to respond_to(:should_generate_new_friendly_id?)
    end
    it "should respond to set_custom_slug" do
      expect(item).to respond_to(:set_custom_slug)
    end
    it "should respond to custom_slug" do
      expect(item).to respond_to(:custom_slug)
    end
    it "should respond to clear_bad_characters" do
      expect(item).to respond_to(:clear_bad_characters)
    end
    it "should respond to email_delivery_sent?" do
      expect(item).to respond_to(:email_delivery_sent?)
    end
    it "should respond to email_delivery_queued?" do
      expect(item).to respond_to(:email_delivery_queued?)
    end
    it "should respond to email_delivery_queued_at" do
      expect(item).to respond_to(:email_delivery_queued_at)
    end
    it "should respond to send_email_deliveries" do
      expect(item).to respond_to(:send_email_deliveries)
    end
    it "should respond to posted_to_twitter?" do
      expect(item).to respond_to(:posted_to_twitter?)
    end
    it "should respond to create_twitter_share" do
      expect(item).to respond_to(:create_twitter_share)
    end
    it "should respond to twitter_status" do
      expect(item).to respond_to(:twitter_status)
    end
    it "should respond to sitemap_jobs" do
      expect(item).to respond_to(:sitemap_jobs)
    end
    it "should respond to enqueue_time" do
      expect(item).to respond_to(:enqueue_time)
    end
    it "should respond to main_image" do
      expect(item).to respond_to(:main_image)
    end
    it "should respond to main_image_cache_key" do
      expect(item).to respond_to(:main_image_cache_key)
    end
    it "should respond to comment_cache_key" do
      expect(item).to respond_to(:comment_cache_key)
    end
    it "should respond to has_image?" do
      expect(item).to respond_to(:has_image?)
    end
    it "should respond to cache_key_full" do
      expect(item).to respond_to(:cache_key_full)
    end
    it "should respond to tag_list" do
      expect(item).to respond_to(:tag_list)
    end
    it "should respond to build_stat" do
      expect(item).to respond_to(:build_stat)
    end
    it "should respond to set_status_code" do
      expect(item).to respond_to(:set_status_code)
    end
    it "should respond to admin_permalink" do
      expect(item).to respond_to(:admin_permalink)
    end
    it "should respond to published?" do
      expect(item).to respond_to(:published?)
    end
    it "should respond to language_title_short" do
      expect(item).to respond_to(:language_title_short)
    end
    it "should respond to category_title" do
      expect(item).to respond_to(:category_title)
    end
    it "should respond to language_title" do
      expect(item).to respond_to(:language_title)
    end
    it "should respond to user_title" do
      expect(item).to respond_to(:user_title)
    end
    it "should respond to user_email" do
      expect(item).to respond_to(:user_email)
    end
    it "should respond to keywords_list" do
      expect(item).to respond_to(:keywords_list)
    end
    it "should respond to meta_keywords" do
      expect(item).to respond_to(:meta_keywords)
    end
    it "should respond to keyword_for_solr" do
      expect(item).to respond_to(:keyword_for_solr)
    end
    it "should respond to enqueue_time" do
      expect(item).to respond_to(:enqueue_time)
    end
  end


  describe "Updating Items with undesirable HTML Codes" do
    before(:each) do
      @item = FactoryGirl.create(:item, body: "&lsquo; An &rsquo; Item &ldquo; and &rdquo; &nbsp;")
    end
    it "should not allow to Left/Right Single/Double Quotes" do
      expect(@item.body).to eq("\' An \' Item \" and \"  ")
    end
    it "should replace [Left Single Curly Quotes] with [normal single quote]" do
      @item.body = "Item &lsquo;"
      @item.save
      expect(@item.body).to eq("Item \'")
    end
    it "should replace [Left Double Curly Quotes] with [normal double quotes]" do
      @item.body = "Item &ldquo;"
      @item.save
      expect(@item.body).to eq("Item \"")
    end
    it "should replace [Right Single Curly Quotes] with [normal single quote]" do
      @item.body = "Item &rsquo;"
      @item.save
      expect(@item.body).to eq("Item \'")
    end
    it "should replace [Right Double Curly Quotes] with [normal double quotes]" do
      @item.body = "Item &rdquo;"
      @item.save
      expect(@item.body).to eq("Item \"")
    end
    it "should replace &nbsp; with normal spaces" do
      @item.body = "The&nbsp;Item"
      @item.save
      expect(@item.body).to eq("The Item")
    end
    it "should replace [en dash &ndash;] with [minus sign]" do
      @item.body = "The&ndash;Item"
      @item.save
      expect(@item.body).to eq("The-Item")
    end
    it "should replace [em dash &mdash;] with [minus sign]" do
      @item.body = "The&mdash;Item"
      @item.save
      expect(@item.body).to eq("The-Item")
    end
    it "should replace [acute accent with no letter] with [single quote]" do
      @item.body = "The&#180;Item"
      @item.save
      expect(@item.body).to eq("The\'Item")
      expect(@item.body).to eq("The'Item")
    end
    it "should replace [grave accent/reversed apostrophe with no letter] with [single quote]" do
      @item.body = "The&#96;Item"
      @item.save
      expect(@item.body).to eq("The\'Item")
      expect(@item.body).to eq("The'Item")
    end
    it "should replace [hellip] with [...]" do
      @item.body = "The&hellip;Item"
      @item.save
      expect(@item.body).to eq("The...Item")
    end
  end

  describe "Creating Item with Subscription" do
    before(:each) do
      @item = FactoryGirl.create(:item, draft: false, send_emails: "1")
    end
    it "should create an EmailDelivery resource" do
      expect(@item.email_deliveries).not_to eq([])
      expect(@item.email_deliveries.last).to eq(EmailDelivery.first)
    end
    it "should have only one EmailDelivery resource" do
      expect(@item.email_deliveries.count).to eq(1)
    end
    it "should not re-create an EmailDelivery resource after saving" do
      @item.draft = false
      @item.save
      expect(@item.email_deliveries.count).to eq(1)
    end
    it "should have send_at date" do
      expect(@item.email_deliveries.first.send_at).not_to eq(nil)
    end
    it "should have send_at queue time greater then publication date" do
      expect(@item.email_deliveries.first.send_at.to_i).to greater_than(@item.published_at.to_i)
    end
    it "should not yet have sent the email" do
      expect(@item.email_delivery_sent?).to eq(false)
    end
  end

  describe "Creating Draft Item without Subscription" do
    before(:each) do
      @item = FactoryGirl.create(:item, draft: true)
    end
    it "should not create an EmailDelivery resource" do
      expect(@item.email_deliveries).to eq([])
      expect(@item.email_deliveries.count).to eq(0)
    end
    it "should re-create an EmailDelivery resource after saving" do
      @item.draft = false
      @item.send_emails = "1"
      @item.save
      expect(@item.email_deliveries.count).to eq(1)
    end
    it "should says it already sent the email" do
      expect(@item.email_delivery_sent?).to eq(false)
    end
  end


  describe "Creating Non-Draft Item without Subscription" do
    before(:each) do
      @item = FactoryGirl.create(:item, draft: true, send_emails: "1")
    end
    it "should not create an EmailDelivery resource" do
      expect(@item.email_deliveries).to eq([])
      expect(@item.email_deliveries.count).to eq(0)
    end
    it "should re-create an EmailDelivery resource after saving" do
      @item.draft = false
      @item.save
      expect(@item.email_deliveries.count).to eq(1)
    end
    it "should have already sent the email" do
      expect(@item.email_delivery_sent?).to eq(false)
    end
    it "should enqueue the email delivery" do
      expect(@item.email_delivery_queued?).to eq(false)
    end
  end

  describe "Creating Item with future publication should enqueue the emails" do
    before(:each) do
      @item = FactoryGirl.create(:item, published_at: Time.now+600, send_emails: "1")
    end
    it "should enqueue the email delivery" do
      expect(@item.email_delivery_queued?).to eq(true)
    end
    it "should not send the email yet" do
      expect(@item.email_delivery_sent?).to eq(false)
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
      expect(lambda {Item.create(valid_item_attributes)}).not_to raise_error
    end
    it "should allow to edit an Item" do
      @item.title = "A New item..."
      expect(lambda {@item.save}).not_to raise_error
    end
    it "should delete an Item" do
      expect(lambda {@item.destroy}).not_to raise_error
    end
  end


end
