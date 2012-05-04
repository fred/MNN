require 'spec_helper'

describe AuthorsController do
  
  before(:each) do
    @item = FactoryGirl.create(:item_highlight)
    @author = @item.user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: @author.id
      response.should be_success
    end
  end

  describe "GET 'show.rss'" do
    it "returns http success for author rss" do
      get 'show', id: @author.id, format: "rss"
      response.should be_success
    end
  end


  describe "GET 'show.atom'" do
    it "returns http success for author atom" do
      get 'show', id: @author.id, format: "atom"
      response.should be_success
    end
  end

end
