require 'spec_helper'

describe "/shared/items" do
  before(:each) do
    @item = FactoryGirl.create(:item)
    @item2 = FactoryGirl.create(:item2)
    @items = Item.all
    assign(:items, @items)
    render '/shared/items', format: [:atom], handlers: [:builder]
  end
  
  it "should have a channel element" do
    expect(rendered).to match(/channel/)
  end
  
  it "should have a item element" do
    expect(rendered).to match(/item/)
  end
  
  it "should contain item url" do
    expect(rendered).to contain(url_for(@item))
    expect(rendered).to contain(url_for(@item2))
  end
  
  it "should contain item title" do
    expect(rendered).to contain(@item.title)
    expect(rendered).to contain(@item2.title)
  end
  
end
