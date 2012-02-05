require 'spec_helper'

describe Page do
  describe "A Page" do 
    before(:each) do
      @page = Factory(:page)
    end
    it "should be valid" do
      assert_equal true, @page.valid?
    end
    it "should require a title" do
      @page.title = nil
      assert_equal false, @page.valid?
    end
    it "should require a body" do
      @page.body = nil
      assert_equal false, @page.valid?
    end
  end
end
