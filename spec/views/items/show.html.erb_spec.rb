require 'spec_helper'

describe "items/show" do
  include Devise::TestHelpers
  include EnableSunspot
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @item = assign(:item, stub_model(Item,
      :title => "Title",
      :category_id => 1,
      :body => "Some body",
      :abstract => "Abstract",
      :created_at => Time.now,
      :updated_at => Time.now,
      :published_at => Time.now
    ))
    @item.attachments << FactoryGirl.create(:attachment)
    Sunspot.commit
  end

  it "should render required attributes from item" do
    render
    assert_select "article>h1", :text => @item.title.to_s, :count => 1
    assert_select "div#item_body", :text => @item.body.to_s, :count => 1
  end
  it "should truncate image caption to 97 characters plus '...'" do
    render
    assert_select "figcaption", :text => (@item.main_image.title[0..96]+"..."), :count => 1
  end
  it "should show main image for item" do
    render
    assert_select "img#main_image", :src => (@item.main_image.image.medium), :count => 1
  end
end
