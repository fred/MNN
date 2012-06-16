require 'spec_helper'
# require 'carrierwave/test/matchers'

describe Document do
  describe "Existence" do 
    before(:each) do
      @document = FactoryGirl.create(:document)
    end
    it "should be valid" do
      assert_equal true, @document.valid?
    end
    it "should have data" do
      assert_equal true, @document.data?
    end
  end
end