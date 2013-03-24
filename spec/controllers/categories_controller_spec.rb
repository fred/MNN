require 'spec_helper'

describe CategoriesController do

  before(:each) do
    @item = FactoryGirl.create(:item)
    @category = @item.category
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: @category.id
      expect(response).to be_success
    end
  end

  #describe "GET show with invalid encoding params" do
  #  it "assigns the requested item as item" do
  #    get :show, id: "abc-a\xFCe"
  #    expect(response).to redirect_to(root_path)
  #  end
  #end

end
