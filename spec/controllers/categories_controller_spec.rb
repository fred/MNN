require 'spec_helper'

describe CategoriesController do
  
  before(:each) do
    @item = Factory(:item)
    @category = @item.category
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => @category.id
      response.should be_success
    end
  end

end
