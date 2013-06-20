require 'spec_helper'

describe User do

  describe "with Job Queues" do
    it "should enqueue the confimation, welcome and admin emails (3 emails)" do
      expect(->{ 
        user = FactoryGirl.build(:user)
        user.confirm!
      }).to change(ActionMailer::Base.deliveries, :count).by(3)
    end
  end

end
