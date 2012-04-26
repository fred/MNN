require 'spec_helper'
# require 'carrierwave/test/matchers'

describe Attachment do
  describe "An Attachment" do 
    before(:each) do
      @attachment = FactoryGirl.create(:attachment)
    end
    it "should be valid" do
      assert_equal true, @attachment.valid?
    end
    it "should have an image" do
      assert_equal true, @attachment.image?
    end
  end
end