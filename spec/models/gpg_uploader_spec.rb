require 'spec_helper'
# require 'carrierwave/test/matchers'

describe User do
  describe "with a GPG file" do 
    before(:each) do
      @user = FactoryGirl.create(:user_with_gpg)
    end
    it "should be valid" do
      assert_equal true, @user.valid?
    end
    it "should have a GPG file" do
      assert_equal true, @user.gpg?
    end
  end
end