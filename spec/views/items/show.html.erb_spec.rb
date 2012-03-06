require 'spec_helper'

describe "items/show" do
  include EnableSunspot
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :title => "Title",
      :category_id => 1,
      :body => "Some body",
      :abstract => "Abstract",
      :created_at => Time.now,
      :updated_at => Time.now,
      :published_at => Time.now
    ))
    Sunspot.commit
  end

  it "should render required attributes from item" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/Title/)
    assert_select "article>h1", :text => @item.title.to_s, :count => 1
    assert_select "div#item_body", :text => @item.body.to_s, :count => 1
  end
end
