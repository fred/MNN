require 'spec_helper'

describe ItemsController do
  include ItemSpecHelper
  include EnableSunspot
  
  before(:each) do
    @item = FactoryGirl.create(:item)
    @category = @item.category
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
    it "assigns all items as @items" do
      # item = Item.create! valid_item_attributes
      get :index
      assigns(:items).should eq([@item])
    end
  end
  
  describe "GET show" do
    it "assigns the requested item as @item" do
      # item = Item.create! valid_item_attributes
      get :show, id: @item.id
      assigns(:item).should eq(@item)
    end
  end
  
  describe "GET show for same user" do
    it "increases the views_counter of @item" do
      get :show, id: @item.id
      @new_item = Item.find(@item.id)
      assert_equal 1, @new_item.item_stat.views_counter
    end
    it "does not increase the views_counter again" do
      10.times do
        get :show, id: @item.id
      end
      @new_item = Item.find(@item.id)
      assert_equal 1, @new_item.item_stat.views_counter
    end
  end
  describe "GET show for different users" do
    it "increases the views_counter of @item" do
      get :show, id: @item.id
      session[:view_items] = Set.new
      get :show, id: @item.id
      @new_item = Item.find(@item.id)
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
        get :search, q: @item.title
        assigns(:items).should eq([@item])
      end
    end
  end
  
  # describe "GET new" do
  #   it "assigns a new item as @item" do
  #     get :new
  #     assigns(:item).should be_a_new(Item)
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "assigns the requested item as @item" do
  #     item = Item.create! valid_item_attributes
  #     get :edit, id: item.id
  #     assigns(:item).should eq(item)
  #   end
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new Item" do
  #       expect {
  #         post :create, item: valid_item_attributes
  #       }.to change(Item, :count).by(1)
  #     end
  # 
  #     it "assigns a newly created item as @item" do
  #       post :create, item: valid_item_attributes
  #       assigns(:item).should be_a(Item)
  #       assigns(:item).should be_persisted
  #     end
  # 
  #     it "redirects to the created item" do
  #       post :create, item: valid_item_attributes
  #       response.should redirect_to(Item.last)
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved item as @item" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Item.any_instance.stub(:save).and_return(false)
  #       post :create, item: {}
  #       assigns(:item).should be_a_new(Item)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Item.any_instance.stub(:save).and_return(false)
  #       post :create, item: {}
  #       response.should render_template("new")
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested item" do
  #       item = Item.create! valid_item_attributes
  #       # Assuming there are no other items in the database, this
  #       # specifies that the Item created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       Item.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, id: item.id, item: {'these' => 'params'}
  #     end
  # 
  #     it "assigns the requested item as @item" do
  #       item = Item.create! valid_item_attributes
  #       put :update, id: item.id, item: valid_item_attributes
  #       assigns(:item).should eq(item)
  #     end
  # 
  #     it "redirects to the item" do
  #       item = Item.create! valid_item_attributes
  #       put :update, id: item.id, item: valid_item_attributes
  #       response.should redirect_to(item)
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns the item as @item" do
  #       item = Item.create! valid_item_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Item.any_instance.stub(:save).and_return(false)
  #       put :update, id: item.id, item: {}
  #       assigns(:item).should eq(item)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       item = Item.create! valid_item_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       Item.any_instance.stub(:save).and_return(false)
  #       put :update, id: item.id, item: {}
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested item" do
  #     item = Item.create! valid_item_attributes
  #     expect {
  #       delete :destroy, id: item.id
  #     }.to change(Item, :count).by(-1)
  #   end
  # 
  #   it "redirects to the items list" do
  #     item = Item.create! valid_item_attributes
  #     delete :destroy, id: item.id
  #     response.should redirect_to(items_url)
  #   end
  # end

end
