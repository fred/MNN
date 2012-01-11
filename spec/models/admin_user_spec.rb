require 'spec_helper'

describe AdminUser do
  describe "An Admin User" do 
    before(:each) do
      @admin_user = Factory(:admin_user)
    end
    it "should be valid" do
      assert_equal true, @admin_user.valid?
    end
    it "should require a email" do
      @admin_user.email = nil
      assert_equal false, @admin_user.valid?
    end
  end
end
