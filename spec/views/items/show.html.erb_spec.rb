require 'spec_helper'

describe "items/show.html.erb" do
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
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/Abstract/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # rendered.should match(/MyTextBody/)
    
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article>h1", :text => "Title".to_s, :count => 1
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "article>section", :text => "Some body".to_s, :count => 1
  end
end
