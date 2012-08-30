require 'spec_helper'

describe Comment do

  describe "with an email alert to admin" do
    it 'should send an email to admin' do
      ->{ FactoryGirl.create(:comment) }.should change(ActionMailer::Base.deliveries, :count).by(4)
    end
    it 'should not send an email to the users' do
      ->{ FactoryGirl.create(:comment, subscribe: true) }.should change(ActionMailer::Base.deliveries, :count).by(4)
    end
  end

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
  
  describe "Notification" do 
    before(:each) do
      @comment = FactoryGirl.create(:comment, subscribe: true)
    end
    it "should create a CommentSubscription record" do
      @comment.commentable.comment_subscriptions.should_not eq([])
    end
    it "should create a CommentSubscription for the user commenting" do
      @comment.commentable.comment_subscriptions.first.user.should eq(@comment.owner)
    end
    it "should create a CommentSubscription for the item" do
      @comment.commentable.comment_subscriptions.first.item.should eq(@comment.commentable)
    end
    it "should create only one CommentSubscription for the user" do
      ->{
        comment = Comment.new
        comment.body = @comment.body
        comment.commentable = @comment.commentable
        comment.owner = @comment.owner
        comment.subscribe = true
        comment.save
      }.should_not change(CommentSubscription, :count)
      ->{
        comment = Comment.new
        comment.body = @comment.body
        comment.commentable = @comment.commentable
        comment.owner = @comment.owner
        comment.subscribe = true
        comment.save
      }.should_not change(CommentSubscription, :count)
    end
  end

end
