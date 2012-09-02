require 'spec_helper'

describe AdminUser do
  describe "An Admin User" do 
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
    end
    it "should be valid" do
      assert_equal true, @admin_user.valid?
    end
    it "should require a email" do
      @admin_user.email = nil
      assert_equal false, @admin_user.valid?
    end
    it "should return true on is_admin?" do
      expect(@admin_user.is_admin?).to eq(true)
    end
    it "should allow to Dowgrade user" do
      @admin_user.downgrade = "1"
      @admin_user.save
      expect(@admin_user.is_admin?).to eq(false)
    end
  end
end
