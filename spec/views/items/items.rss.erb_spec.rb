require 'spec_helper'

describe "/shared/items" do
  before(:each) do
    @item = FactoryGirl.create(:item)
    @item2 = FactoryGirl.create(:item2)
    @items = Item.all
    assign(:items, @items)
    render '/shared/items', :format => [:rss], :handlers => [:builder]
  end
  
  it "should have a channel element" do
    rendered.should =~ /channel/
  end
  
  it "should have a item element" do
    rendered.should =~ /item/
  end
  
  it "should contain item url" do
    rendered.should contain(url_for(@item))
    rendered.should contain(url_for(@item2))
  end
  
  it "should contain item title" do
    rendered.should contain(@item.title)
    rendered.should contain(@item2.title)
  end
  
end
