require 'spec_helper'

describe Role do
  describe "A Role" do 
    before(:each) do
      @role = FactoryGirl.create(:role)
    end
    it "should be valid" do
      assert_equal true, @role.valid?
    end
    it "should require a title" do
      @role.title = nil
      assert_equal false, @role.valid?
    end
  end
  
end
