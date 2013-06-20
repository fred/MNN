require 'spec_helper'

describe Comment do

  describe "with an email alert to admin" do
    it 'should send an email to admin' do
      expect{FactoryGirl.create(:comment)}.to change(ActionMailer::Base.deliveries, :count).by(5)
    end
    it 'should not send an email to the users' do
      expect{FactoryGirl.create(:comment, subscribe: true)}.to change(ActionMailer::Base.deliveries, :count).by(5)
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
      @comment.owner.confirm!
    end
    it "should create a CommentSubscription record" do
      expect(@comment.commentable.comment_subscriptions).not_to eq([])
    end
    it "should create a CommentSubscription for the user commenting" do
      expect(@comment.commentable.comment_subscriptions.first.user).to eq(@comment.owner)
    end
    it "should create a CommentSubscription for the item" do
      expect(@comment.commentable.comment_subscriptions.first.item).to eq(@comment.commentable)
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
