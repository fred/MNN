require 'spec_helper'

describe Item do

  describe "with Job Queues" do
    require 'sidekiq/testing'
    it "should enqueue the email subscription job" do
      expect {
        FactoryGirl.create(:item, draft: false, published_at: Time.now, send_emails: "1")
      }.to change(SubscriptionQueue.jobs, :size).by(1)
    end
    it "should enqueue the email subscription job in 600 seconds" do
      expect {
        FactoryGirl.create(:item, draft: false, published_at: Time.now+600, send_emails: "1")
      }.to change(SubscriptionQueue.jobs, :size).by(1)
    end
  end

  describe "with Job Queues" do
    require 'sidekiq/testing'
    it "should enqueue the sitemap generation job" do
      expect {
        FactoryGirl.create(:item, draft: false, published_at: Time.now)
      }.to change(SitemapQueue.jobs, :size).by(1)
    end
    it "should enqueue the email subscription job in 600 seconds" do
      expect {
        FactoryGirl.create(:item, draft: false, published_at: Time.now+600)
      }.to change(SitemapQueue.jobs, :size).by(1)
    end
  end

end
