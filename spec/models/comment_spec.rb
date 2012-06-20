require 'spec_helper'

describe Comment do

  describe "Validity" do 
    before(:each) do
      @comment = FactoryGirl.build(:comment)
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
  
  describe "with an email alert to admin" do
    it 'should send an email to admin' do
      ->{ FactoryGirl.create(:comment) }.should change(ActionMailer::Base.deliveries, :count).by(3)
    end
  end

end
