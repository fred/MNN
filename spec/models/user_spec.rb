require 'spec_helper'

describe User do
  describe "A User" do 
    before(:each) do
      @user = Factory(:user)
    end
    it "should be valid" do
      assert_equal true, @user.valid?
    end
    it "should require a email" do
      @user.email = nil
      assert_equal false, @user.valid?
    end
  end
end
