require 'spec_helper'

describe Admin::ItemsController do
  include ItemSpecHelper
  
  describe "Not Logged in users" do
    describe "GET index" do
      it "redirects to the login page" do
        get :index
        response.should redirect_to(new_admin_user_session_path)
      end
    end
  end

  describe "Logged in as an Author" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_author)
      @user.roles << @role
      sign_in @user
    end
    describe "Others Item" do
      before (:each) do
        @item = FactoryGirl.create(:item, user_id: @user.id.to_i+99)
      end
      describe "GET index" do
        it "Should Show @items array" do
          get :index
          assigns(:items).should eq([@item])
        end
      end
      describe "GET show" do
        it "Should Show @item" do
          get :show, id: @item.id
          assigns(:item).should eq(@item)
        end
      end
      describe "GET edit" do
        it "Should have @item" do
          get :edit, id: @item.id
          response.should redirect_to(admin_dashboard_path)
        end
      end
    end
    describe "Existing Item" do
      before (:each) do
        @item = FactoryGirl.create(:item, user_id: @user.id)
      end
      describe "GET index" do
        it "Should Show @items array" do
          get :index
          assigns(:items).should eq([@item])
        end
      end
      describe "GET show" do
        it "Should Show @item" do
          get :show, id: @item.id
          assigns(:item).should eq(@item)
        end
      end
      describe "GET edit" do
        it "Should have @item" do
          get :edit, id: @item.id
          assigns(:item).should eq(@item)
        end
        it "Should have @item not as new record" do
          get :edit, id: @item.id
          assigns(:item).should_not be_new_record
        end
      end
    end
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Item" do
          expect {
            post :create, item: valid_item_attributes
          }.to change(Item, :count).by(1)
        end
        it "should only create draft items" do
          post :create, item: valid_item_attributes
          assigns(:item).draft.should eq(true)
        end
        it "assigns a newly created user as @user" do
          post :create, item: valid_item_attributes
          assigns(:item).should be_valid
          assigns(:item).should be_a(Item)
          assigns(:item).should be_persisted
        end
        it "redirects to the created item" do
          post :create, item: valid_item_attributes
          assigns(:item).should be_valid
          response.should redirect_to(admin_item_path(assigns(:item)))
        end
      end
      describe "with invalid params" do
        it "assigns a newly created but unsaved user as @item" do
          post :create, item: {}
          assigns(:item).should be_a_new(Item)
        end
        it "re-renders the 'new' template" do
          post :create, item: {}
          response.should render_template("new")
        end
      end
    end
    describe "Deleting Own Articles" do
      before (:each) do
        @item = FactoryGirl.create(:item, user_id: @user.id)
      end
      it "destroys the requested item" do
        expect {
          delete :destroy, {id: @item.to_param}
        }.to change(Item, :count).by(-1)
      end
      it "redirects to the items list" do
        delete :destroy, {id: @item.to_param}
        response.should redirect_to(admin_items_url)
      end
    end
    describe "Deleting others Articles" do
      before (:each) do
        @item = FactoryGirl.create(:item, user_id: @user.id.to_i+99)
      end
      it "does not destroys the requested item" do
        expect {
          delete :destroy, {id: @item.to_param}
        }.to change(Item, :count).by(0)
      end
      it "redirects to the items list" do
        delete :destroy, {id: @item.to_param}
        response.should redirect_to(admin_dashboard_path)
      end
    end
  end
  
  describe "Logged in Admin users" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_admin)
      @user.roles << @role
      sign_in @user
    end
    
    describe "Existing Item" do
      before (:each) do
        @item = FactoryGirl.create(:item)
      end
      describe "GET index" do
        it "Should Show @items array" do
          get :index
          assigns(:items).should eq([@item])
        end
      end
      describe "GET show" do
        it "Should Show @item" do
          get :show, id: @item.id
          assigns(:item).should eq(@item)
        end
      end
      describe "GET edit" do
        it "Should have @item" do
          get :edit, id: @item.id
          assigns(:item).should eq(@item)
        end
        it "Should have @item not as new record" do
          get :edit, id: @item.id
          assigns(:item).should_not be_new_record
        end
      end
    end

    describe "New Item Record" do
      describe "GET new" do
        it "Should show new item page" do
          get :new
          assigns(:item).should_not be_nil
        end
        it "Should show new item page" do
          get :new
          assigns(:item).should be_new_record
        end
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Item" do
          expect {
            post :create, item: valid_item_attributes
          }.to change(Item, :count).by(1)
        end

        it "assigns a newly created user as @user" do
          post :create, item: valid_item_attributes
          assigns(:item).should be_valid
          assigns(:item).should be_a(Item)
          assigns(:item).should be_persisted
        end

        it "redirects to the created item" do
          post :create, item: valid_item_attributes
          assigns(:item).should be_valid
          response.should redirect_to(admin_item_path(assigns(:item)))
        end
      end
      describe "with invalid params" do
        it "assigns a newly created but unsaved user as @item" do
          post :create, item: {}
          assigns(:item).should be_a_new(Item)
        end
        it "re-renders the 'new' template" do
          post :create, item: {}
          response.should render_template("new")
        end
      end
    end
    
    
    describe "PUT update" do
      before (:each) do
        @item = FactoryGirl.create(:item)
      end
      describe "with valid params" do
        it "updates the requested item" do
          # item = Item.create! valid_item_attributes
          # Item.any_instance.should_receive(:update_attributes).with({'title' => 'old title'})
          put :update, {id: @item.to_param, item: {title: 'new title'}}
        end
        it "assigns the requested item as @item" do
          put :update, {id: @item.to_param, item: valid_item_attributes}
          assigns(:item).should eq(@item)
        end
        it "redirects to the item" do
          put :update, {id: @item.to_param, item: valid_item_attributes}
          response.should redirect_to(admin_item_path(assigns(:item)))
        end
      end
      describe "with invalid params" do
        it "assigns the item as @item" do
          # Trigger the behavior that occurs when invalid params are submitted
          # Item.any_instance.stub(:save).and_return(false)
          put :update, {id: @item.to_param, item: {}}
          assigns(:item).should eq(@item)
        end
      end
    end
    
    describe "DELETE destroy" do
      before (:each) do
        @item = FactoryGirl.create(:item)
      end
      it "destroys the requested item" do
        # item = Item.create! valid_item_attributes
        expect {
          delete :destroy, {id: @item.to_param}
        }.to change(Item, :count).by(-1)
      end
      it "redirects to the items list" do
        # item = Item.create! valid_item_attributes
        delete :destroy, {id: @item.to_param}
        response.should redirect_to(admin_items_url)
      end
    end
    
  end
end
