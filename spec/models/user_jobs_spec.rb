require 'spec_helper'

describe User do

  describe "with Job Queues" do
    require 'sidekiq/testing'
    it "should enqueue the new user email" do
      ->{FactoryGirl.create(:user) }.should change(NewUserMail.jobs, :count).by(1)
    end
  end
end
