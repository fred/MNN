require 'spec_helper'

describe Comment do
  describe "A Score" do 
    before(:each) do
      @comment = FactoryGirl.create(:comment)
    end
    it "should be valid" do
      assert_equal true, @comment.valid?
    end
  end
end
