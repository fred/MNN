require 'spec_helper'

describe User do
  require 'sidekiq/testing/inline'

  describe "with Job Queues" do
    it "should enqueue the new user email and welcome email" do
      ->{ FactoryGirl.create(:user) }.should change(ActionMailer::Base.deliveries, :count).by(2)
    end
  end

end
