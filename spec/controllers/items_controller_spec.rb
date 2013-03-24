require 'spec_helper'

describe ItemsController do
  include ItemSpecHelper
  include EnableSunspot
  let(:item) {FactoryGirl.create(:item)}
  let(:item_draft) {FactoryGirl.create(:item_draft)}
  let(:category) {item.category}

  before(:all) do
    Sunspot.commit
  end

  describe "GET feed" do
    it "show show feed page" do
      get :feed
      expect(response).to be_success
    end
  end

  describe 'GET index' do
    it 'should render RSS XML' do
      get :index, format: 'rss', lang: 'en'
      expect(response).to be_success
      expect(response.headers["Content-Type"]).to eql("application/rss+xml; charset=utf-8")
    end
    it 'should render Atom XML' do
      get :index, format: 'atom', lang: 'en'
      expect(response).to be_success
      expect(response.headers["Content-Type"]).to eql("application/atom+xml; charset=utf-8")
    end
  end

  describe "GET index" do
    it "assigns all items as items" do
      get :index
      expect(assigns(:items)).to eq([item])
    end
  end

  describe "GET show" do
    it "assigns the requested item as item" do
      get :show, id: item.id
      expect(assigns(:item)).to eq(item)
    end
    it "creates a page_view record" do
      get :show, id: item.id
      expect(assigns(:item).page_views).not_to be_empty
      expect(assigns(:item).page_views.count).to eq(1)
    end
    it "renders not found for Draft item" do
      expect(->{ get :show, id: item_draft.id }).to raise_error
    end
  end

  describe "GET show logged in as Admin User" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      sign_in @user
    end
    it "renders Item" do
      get :show, id: item_draft.id
      expect(response).to be_success
      expect(assigns(:item)).to eq(item_draft)
    end
  end

  #describe "GET show with invalid encoding params" do
  #  it "assigns the requested item as item" do
  #    get :show, id: "1000-a\xFCe"
  #    expect(response).to redirect_to(root_path)
  #  end
  #end

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
    it "should increase the views_counter at most 2 per user" do
      get :show, id: item.id
      session[:view_items] = Set.new
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
        expect(assigns(:items)).to eq([])
      end
    end
    describe "with bad search string" do
      it "should show no items" do
        get :search, q: 'asdasdasdasdadadadas'
        expect(assigns(:items)).to eq([])
      end
    end
    describe "with good search string" do
      it "should show some items" do
        get :search, q: item.title
        expect(assigns(:items)).to eq([item])
      end
      it "should store the Search Query" do
        expect(->{ get :search, q: item.title }).to change(SearchQuery, :count).by(1)
      end
    end
  end

end
