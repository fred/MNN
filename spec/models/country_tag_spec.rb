require 'spec_helper'

describe CountryTag do
  describe "A CountryTag" do 
    before(:each) do
      @country_tag = Factory(:country_tag)
    end
    it "should be valid" do
      assert_equal true, @country_tag.valid?
    end
    it "should require a title" do
      @country_tag.title = nil
      assert_equal false, @country_tag.valid?
    end
  end
end