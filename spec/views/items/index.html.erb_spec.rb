require 'spec_helper'

describe "items/index.html.erb" do
  before(:each) do
    item1 = Factory(:item)
    item2 = Factory(:item2)
    @all_items = Item.published.not_draft.order("published_at DESC").page(params[:page], :per_page => 20)
    assign(:items, @all_items)
    # assign(:items, [
    #   stub_model(Item,
    #     :title => "Title",
    #     :abstract => "Abstract",
    #     :category_id => 1,
    #     :body => "MyText",
    #     :created_at => Time.now,
    #     :updated_at => Time.now,
    #     :published_at => Time.now
    #   ),
    #   stub_model(Item,
    #     :title => "Title",
    #     :abstract => "Abstract",
    #     :category_id => 1,
    #     :body => "MyText",
    #     :created_at => Time.now,
    #     :updated_at => Time.now,
    #     :published_at => Time.now
    #   )
    # ])
  end

  it "renders a list of items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article>header>h3", :text => "Some News".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article>section", :text => "Some Abstract".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "article>section", :text => "MyText".to_s, :count => 2
  end
end
