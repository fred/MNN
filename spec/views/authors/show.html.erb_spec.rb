require 'spec_helper'

describe "authors/show" do
  include Devise::TestHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @author = assign(:user, stub_model(User,
      email: "email@email.com",
      name: "my name"
    ))
    @items = Item.page(1)
    sign_in @author
  end
  
  it "should render required attributes from author" do
    render
    assert_select "h3", text: "#{@author.name}", count: 1
  end
end
