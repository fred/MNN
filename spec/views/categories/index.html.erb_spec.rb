require 'spec_helper'

describe "categories/index" do
  before(:each) do
    @item = FactoryGirl.create(:item, featured: true, sticky: true)
    @category = @item.category
    @categories = [@category]
    @latest_items = @category.items.page(1)
    assign(:items, @latest_items)
    render
  end

  it "renders Latest Items box" do
    assert_select "div#highlights > h2 > a", text: "Latest News", count: 1
  end

  it "renders Latest Items with link to all items" do
    assert_select "div#highlights > h2 > a", href: items_path, count: 1
  end

  it "renders stcky item on main box" do
    assert_select "div#highlights > ul > li > span.title", text: @item.title, count: 1
  end

  it "renders the category box" do
    assert_select "div##{@category.slug}>h2", text: @category.title.to_s, count: 1
  end
  
end
