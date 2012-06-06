require 'spec_helper'

describe User do

  describe "with Job Queues" do
    require 'sidekiq/testing'
    it "should enqueue the new user email" do
      expect {
        FactoryGirl.create(:user)
      }.to change(NewUserMail.jobs, :size).by(1)
    end
  end
end
