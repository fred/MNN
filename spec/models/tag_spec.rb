require 'spec_helper'

describe Tag do
  describe "A Tag" do 
    before(:each) do
      @tag = Factory(:tag)
    end
    it "should be valid" do
      assert_equal true, @tag.valid?
    end
    it "should require a title" do
      @tag.title = nil
      assert_equal false, @tag.valid?
    end
  end
end
