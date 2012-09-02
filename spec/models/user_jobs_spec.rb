require 'spec_helper'

describe User do

  describe "with Job Queues" do
    it "should enqueue the new user email and welcome email" do
      expect(->{ FactoryGirl.create(:user) }).to change(ActionMailer::Base.deliveries, :count).by(2)
    end
  end

end
