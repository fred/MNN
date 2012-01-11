require 'spec_helper'

describe Translation do
  describe "A Translation" do 
    before(:each) do
      @translation = Factory(:translation)
    end
    it "should be valid" do
      assert_equal true, @translation.valid?
    end
    it "should require key" do
      @translation.key = nil
      assert_equal false, @translation.valid?
    end
    it "should require locale" do
      @translation.locale = nil
      assert_equal false, @translation.valid?
    end
    it "should require value" do
      @translation.value = nil
      assert_equal false, @translation.valid?
    end
  end
end
