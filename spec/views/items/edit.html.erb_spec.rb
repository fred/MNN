# require 'spec_helper'
# 
# describe "items/edit.html.erb" do
#   before(:each) do
#     @item = assign(:item, stub_model(Item,
#       :title => "MyString",
#       :highlight => "MyString",
#       :body => "MyText"
#     ))
#   end
# 
#   it "renders the edit item form" do
#     render
# 
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => items_path(@item), :method => "post" do
#       assert_select "input#item_title", :name => "item[title]"
#       assert_select "input#item_highlight", :name => "item[highlight]"
#       assert_select "textarea#item_body", :name => "item[body]"
#     end
#   end
# end
