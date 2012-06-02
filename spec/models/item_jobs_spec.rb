require 'spec_helper'

describe Item do
  include NumericMatchers

  describe "with Job Queues" do
    # require 'sidekiq/testing'
    # it "should enqueue the email subscription job" do
    #   expect {
    #     FactoryGirl.create(:item, draft: false, published_at: Time.now, send_emails: "1")
    #   }.to change(SubscriptionQueue.jobs, :size).by(1)
    # end
    # it "should enqueue the Twitter posting job" do
    #   expect {
    #     FactoryGirl.create(:item, draft: false, published_at: Time.now, share_twitter: "1")
    #   }.to change(TwitterQueue.jobs, :size).by(1)
    # end
    # it "should enqueue the Twitter posting job" do
    #   expect {
    #     @item = FactoryGirl.create(:item, draft: false, published_at: Time.now, share_twitter: "1")
    #     @item.comments << Comment.new(body: "testing")
    #   }.to change(TwitterQueue.jobs, :size).by(2)
    # end
  end
end
