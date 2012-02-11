require 'spec_helper'

describe Item do  
  describe "A Simple Item" do 
    before(:each) do
      @item = Factory(:item)
    end
    it "should be valid" do
      @item.should be_valid
    end
    it "should require a category" do
      @item.category_id = nil
      @item.should_not be_valid
    end
    it "should require a title" do
      @item.title = nil
      @item.should_not be_valid
    end
    it "should require a body" do
      @item.body = nil
      @item.should_not be_valid
    end
    it "should not require abstract" do
      @item.abstract = nil
      @item.should be_valid
    end
    it "should not require user_id" do
      @item.user_id = nil
      @item.should be_valid
    end
    
    it "should allow to edit item" do
      @item.title = "A New item..."
      lambda {@item.save}.should_not raise_error
    end
  end
  describe "Editing an a Dirty Item" do
    before(:each) do
      @item = Factory(:item, :title => "Old Title")
    end
    it "should not allow to update a dirty item" do
      @outdated_item = Item.find(@item.id)
      @outdated_item.title = "Added a new title"
      @outdated_item.save
      @item.should_not be_valid
      # lambda {@item.save}.should raise_error
    end
  end
end