require 'spec_helper'

describe Comment do
  describe "A Score" do 
    before(:each) do
      @comment = FactoryGirl.create(:comment)
    end
    it "should be valid" do
      assert_equal true, @comment.valid?
    end
    it "should required body" do
      @comment.body = nil
      assert_equal false, @comment.valid?
    end
    it "should respond_to marked_spam?" do
      assert_equal true, @comment.respond_to?(:marked_spam)
    end
  end
end
