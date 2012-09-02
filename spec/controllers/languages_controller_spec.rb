require 'spec_helper'

describe LanguagesController do
  
  before(:each) do
    @item = FactoryGirl.create(:item)
    @language = @item.language
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: @language.id
      expect(response).to redirect_to(language_items_path(@language))
    end
  end

end
