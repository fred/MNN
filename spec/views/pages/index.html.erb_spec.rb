require 'spec_helper'

describe "pages/index" do
  before(:each) do
    assign(:pages, [
      stub_model(Page,
        :title => "Title",
        :link_title => "Link Title",
        :priority => 1,
        :body => "MyText"
      ),
      stub_model(Page,
        :title => "Title",
        :link_title => "Link Title",
        :priority => 1,
        :body => "MyText"
      )
    ])
  end

  it "renders a list of pages" do
    render
    assert_select "ul>li", :text => "Title".to_s, :count => 2
  end
end
