require 'spec_helper'

describe Item do
  describe "A Simple Listing" do 
    before(:each) do
      @item = Factory(:item)
    end
    it "should be valid" do
      assert_equal true, @item.valid?
    end
    it "should require a category" do
      @item.category_id = nil
      assert_equal false, @item.valid?
    end
    it "should require a title" do
      @item.title = nil
      assert_equal false, @item.valid?
    end
    it "should require a body" do
      @item.body = nil
      assert_equal false, @item.valid?
    end
    it "should not require abstract" do
      @item.abstract = nil
      assert_equal true, @item.valid?
    end
    it "should not require user_id" do
      @item.user_id = nil
      assert_equal true, @item.valid?
    end
  end
end