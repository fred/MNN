require 'spec_helper'

describe PagesController do
  
  before(:all) do
    @page = FactoryGirl.create(:page)
  end

  describe "GET index" do
    it "assigns all pages as @pages" do
      get :index, {}
      expect(assigns(:pages)).to eq([@page])
    end
  end

  describe "GET show" do
    it "assigns the requested page as @page" do
      get :show, {id: @page.to_param}
      expect(assigns(:page)).to eq(@page)
    end
  end

end
