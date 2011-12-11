require 'spec_helper'

describe "items/new.html.erb" do
  before(:each) do
    assign(:item, stub_model(Item,
      :title => "MyString",
      :highlight => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_title", :name => "item[title]"
      assert_select "input#item_highlight", :name => "item[highlight]"
      assert_select "textarea#item_body", :name => "item[body]"
    end
  end
end
