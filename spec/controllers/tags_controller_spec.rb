require 'spec_helper'

describe TagsController do
  
  before(:each) do
    @item = FactoryGirl.create(:item)
    @tag = FactoryGirl.create(:tag)
    @item.tags << @tag
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: @tag.id
      expect(response).to be_success
    end
  end

end
