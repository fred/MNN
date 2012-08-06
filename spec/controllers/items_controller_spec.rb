require 'spec_helper'

describe ItemsController do
  include ItemSpecHelper
  include EnableSunspot
  let(:item) {FactoryGirl.create(:item)}
  let(:category) {item.category}

  before(:all) do
    Sunspot.commit
  end
  
  describe "GET feed" do
    it "show show feed page" do
      get :feed
      response.should be_success
    end
  end
  
  describe 'GET index' do
    it 'should render RSS XML' do
      get :index, format: 'rss', lang: 'en'
      response.should be_success
      response.headers["Content-Type"].should eql("application/rss+xml; charset=utf-8")
    end
    it 'should render Atom XML' do
      get :index, format: 'atom', lang: 'en'
      response.should be_success
      response.headers["Content-Type"].should eql("application/atom+xml; charset=utf-8")
    end
  end
  
  describe "GET index" do
    it "assigns all items as items" do
      # item = Item.create! valid_item_attributes
      get :index
      assigns(:items).should eq([item])
    end
  end
  
  describe "GET show" do
    it "assigns the requested item as item" do
      # item = Item.create! valid_item_attributes
      get :show, id: item.id
      assigns(:item).should eq(item)
    end
  end
  
  describe "GET show for same user" do
    it "increases the views_counter of item" do
      get :show, id: item.id
      @new_item = Item.find(item.id)
      assert_equal 1, @new_item.item_stat.views_counter
    end
    it "does not increase the views_counter again" do
      10.times do
        get :show, id: item.id
      end
      @new_item = Item.find(item.id)
      assert_equal 1, @new_item.item_stat.views_counter
    end
  end
  describe "GET show for different users" do
    it "increases the views_counter of item" do
      get :show, id: item.id
      session[:view_items] = Set.new
      get :show, id: item.id
      @new_item = Item.find(item.id)
      assert_equal 2, @new_item.item_stat.views_counter
    end
  end

  describe "GET search" do
    describe "with empty search string" do
      it "should show no items" do
        get :search, q: ''
        assigns(:items).should eq([])
      end
    end
    describe "with bad search string" do
      it "should show no items" do
        get :search, q: 'asdasdasdasdadadadas'
        assigns(:items).should eq([])
      end
    end
    describe "with good search string" do
      it "should show some items" do
        get :search, q: item.title
        assigns(:items).should eq([item])
      end
    end
  end

end
