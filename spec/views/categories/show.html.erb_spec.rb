require 'spec_helper'

describe "categories/show" do
  before(:each) do
    @item = FactoryGirl.create(:item, featured: true, sticky: true)
    @category = @item.category
    @items = @category.items.page(1)
    render
  end

  it "should render category title inside an H1" do
    expect(view.content_for(:breadcrumb)).to contain(@category.title)
  end
  it "should render item in an article tag" do
    assert_select "article#item_#{@item.id} > header > h2 > a", text: @item.title, count: 1
    assert_select "article#item_#{@item.id} > header > h2 > a", href: item_path(@item), count: 1
  end
end
