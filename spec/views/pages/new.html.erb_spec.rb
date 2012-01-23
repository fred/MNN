# require 'spec_helper'
# 
# describe "pages/new" do
#   before(:each) do
#     assign(:page, stub_model(Page,
#       :title => "MyString",
#       :link_title => "MyString",
#       :priority => 1,
#       :body => "MyText"
#     ).as_new_record)
#   end
# 
#   it "renders new page form" do
#     render
# 
#     # Run the generator again with the --webrat flag if you want to use webrat matchers
#     assert_select "form", :action => pages_path, :method => "post" do
#       assert_select "input#page_title", :name => "page[title]"
#       assert_select "input#page_link_title", :name => "page[link_title]"
#       assert_select "input#page_priority", :name => "page[priority]"
#       assert_select "textarea#page_body", :name => "page[body]"
#     end
#   end
# end
