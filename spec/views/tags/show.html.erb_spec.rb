require 'spec_helper'

describe "tags/show" do
  before(:each) do
    @tag = Factory(:tag)
    @item = Factory(:item)
    @item.tags << @tag
    @items = @tag.items.page(1)
    @tags = Tag.all
    assign(:tags, @tags)
    assign(:items, @items)
    render
  end
  
  it "renders a list of items with headline as link" do
    assert_select "article#item_#{@item.id} > header > h3 > a", :text => @item.title.to_s, :count => 1
    assert_select "article#item_#{@item.id} > header > h3 > a", :href => items_path(@item), :count => 1
  end
  
  it "renders a list of items with abstraction is a section" do
    assert_select "article#item_#{@item.id} > section", :text => @item.abstract.to_s, :count => 1
  end
  
  it "renders a list of items with source is a section" do
    assert_select "article#item_#{@item.id} > section > span.source_url", :href => @item.source_url.to_s, :count => 1
  end
  
  it "renders a list of items with pubdate is a date field" do
    assert_select "article#item_#{@item.id} > section > span.date", :pubdate => time_tag(@item.published_at, :pubdate => true), :count => 1
  end
  
  it "renders a list of items with tags" do
    assert_select "article#item_#{@item.id} > section > ul.tags > li > a", :text => @tag.title.to_s, :count => 1
  end
  
  
end
