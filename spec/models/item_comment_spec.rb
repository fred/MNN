require 'spec_helper'

describe Item do
  include NumericMatchers

  describe "With Comment" do
    before(:each) do
      @item = FactoryGirl.create(:item)
      @user = FactoryGirl.create(:user)
      @comment = Comment.new(body: "hello")
      @comment.owner = @user
    end
    it "should update column last_commented_at" do
      @last_commented_at = @item.last_commented_at
      @item.comments << @comment
      @item.reload
      sleep 1
      expect(@item.reload.last_commented_at.to_i).not_to eq(@last_commented_at.to_i)
    end

    it "should not update column update_at" do
      @updated_at = @item.updated_at
      @item.comments << @comment
      @item.reload
      expect(@item.reload.updated_at.to_i).to eq(@updated_at.to_i)
    end

  end
end