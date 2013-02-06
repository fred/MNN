require 'spec_helper'

describe "items/index" do
  before(:each) do
    @item = FactoryGirl.create(:item)
    @item2 = FactoryGirl.create(:item2)
    @items = Item.published.not_draft.order("published_at DESC").page(params[:page], per_page: 20)
    assign(:items, @items)
    render
  end

  it "renders a list of items" do
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article>header>h2", text: "Some News".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article>section", text: "Some Abstract".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "article>section", text: "MyText".to_s, count: 2
  end
  
  
  it "renders a list of items with headline as link" do
    assert_select "article#item_#{@item.id} > header > h2 > a", text: @item.title.to_s, count: 1
    assert_select "article#item_#{@item.id} > header > h2 > a", href: items_path(@item), count: 1
  end
  
  it "renders a list of items with abstraction is a section" do
    assert_select "article#item_#{@item.id} > section", text: @item.abstract.to_s, count: 1
  end
  
  it "renders a list of items with source is a section" do
    assert_select "article#item_#{@item.id} > section > span.source_url", href: @item.source_url.to_s, count: 1
  end
  
  it "renders a list of items with pubdate is a date field" do
    assert_select "article#item_#{@item.id} > section > span.date", pubdate: time_tag(@item.published_at, pubdate: true), count: 1
  end
  
end
