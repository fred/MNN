require 'spec_helper'

describe GeneralTag do
  describe "A GeneralTag" do 
    before(:each) do
      @general_tag = Factory(:general_tag)
    end
    it "should be valid" do
      assert_equal true, @general_tag.valid?
    end
    it "should require a title" do
      @general_tag.title = nil
      assert_equal false, @general_tag.valid?
    end
  end
  
end
