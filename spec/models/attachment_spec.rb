require 'spec_helper'
require 'carrierwave/test/matchers'

describe Attachment do
  describe "An Attachment" do 
    before(:each) do
      @attachment = Factory(:attachment)
    end
    it "should be valid" do
      assert_equal true, @attachment.valid?
    end
  end
end