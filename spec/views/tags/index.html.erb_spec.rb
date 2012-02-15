require 'spec_helper'

describe "tags/index" do
  before(:each) do
    @tag = Factory(:tag)
    @tags = Tag.all
    assign(:tags, @tags)
  end

  it "renders a list of tags with a link" do
    render
    assert_select "div.all_tags > div#tag_#{@tag.id} > a", :text => @tag.title.to_s, :count => 1
  end
  it "renders a list of tags with item counters" do
    render
    assert_select "div.all_tags > div#tag_#{@tag.id}", :text => "#{@tag.title.to_s} (#{@tag.items.count})", :count => 1
  end
end
