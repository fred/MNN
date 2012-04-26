require 'spec_helper'

describe Category do
  describe "A Category" do 
    before(:each) do
      @category = FactoryGirl.create(:category)
    end
    it "should be valid" do
      assert_equal true, @category.valid?
    end
    it "should require a title" do
      @category.title = nil
      assert_equal false, @category.valid?
    end
    it "should require description" do
      @category.description = nil
      assert_equal false, @category.valid?
    end
  end
end