require 'spec_helper'

describe Admin::ItemsController do
  include ItemSpecHelper
  
  describe "Not Logged in users" do
    describe "GET index" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_admin_user_session_path)
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
          expect(assigns(:items)).to eq([@item])
        end
      end
      describe "GET show" do
        it "Should Show @item" do
          get :show, id: @item.id
          expect(assigns(:item)).to eq(@item)
        end
      end
      describe "GET edit" do
        it "Should have @item" do
          get :edit, id: @item.id
          expect(response).to redirect_to(admin_dashboard_path)
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
          expect(assigns(:items)).to eq([@item])
        end
      end
      describe "GET show" do
        it "Should Show @item" do
          get :show, id: @item.id
          expect(assigns(:item)).to eq(@item)
        end
      end
      describe "GET edit" do
        it "Should have @item" do
          get :edit, id: @item.id
          expect(assigns(:item)).to eq(@item)
        end
        it "Should have @item not as new record" do
          get :edit, id: @item.id
          expect(assigns(:item)).not_to be_new_record
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
          expect(assigns(:item).draft).to eq(true)
        end
        it "assigns a newly created user as @user" do
          post :create, item: valid_item_attributes
          expect(assigns(:item)).to be_valid
          expect(assigns(:item)).to be_a(Item)
          expect(assigns(:item)).to be_persisted
        end
        it "redirects to the created item" do
          post :create, item: valid_item_attributes
          expect(assigns(:item)).to be_valid
          expect(response).to redirect_to(admin_item_path(assigns(:item)))
        end
      end
      describe "with invalid params" do
        it "assigns a newly created but unsaved user as @item" do
          post :create, item: {}
          expect(assigns(:item)).to be_a_new(Item)
        end
        it "re-renders the 'new' template" do
          post :create, item: {}
          expect(response).to render_template("new")
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
        expect(response).to redirect_to(admin_items_url)
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
        expect(response).to redirect_to(admin_dashboard_path)
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
          expect(assigns(:items)).to eq([@item])
        end
      end
      describe "GET show" do
        it "Should Show @item" do
          get :show, id: @item.id
          expect(assigns(:item)).to eq(@item)
        end
      end
      describe "GET edit" do
        it "Should have @item" do
          get :edit, id: @item.id
          expect(assigns(:item)).to eq(@item)
        end
        it "Should have @item not as new record" do
          get :edit, id: @item.id
          expect(assigns(:item)).not_to be_new_record
        end
      end
    end

    describe "New Item Record" do
      describe "GET new" do
        it "Should show new item page" do
          get :new
          expect(assigns(:item)).not_to be_nil
        end
        it "Should show new item page" do
          get :new
          expect(assigns(:item)).to be_new_record
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
          expect(assigns(:item)).to be_valid
          expect(assigns(:item)).to be_a(Item)
          expect(assigns(:item)).to be_persisted
        end

        it "redirects to the created item" do
          post :create, item: valid_item_attributes
          expect(assigns(:item)).to be_valid
          expect(response).to redirect_to(admin_item_path(assigns(:item)))
        end
      end
      describe "with invalid params" do
        it "assigns a newly created but unsaved user as @item" do
          post :create, item: {}
          expect(assigns(:item)).to be_a_new(Item)
        end
        it "re-renders the 'new' template" do
          post :create, item: {}
          expect(response).to render_template("new")
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
          expect(assigns(:item)).to eq(@item)
        end
        it "redirects to the item" do
          put :update, {id: @item.to_param, item: valid_item_attributes}
          expect(response).to redirect_to(assigns(:item))
        end
      end
      describe "with invalid params" do
        it "assigns the item as @item" do
          # Trigger the behavior that occurs when invalid params are submitted
          # Item.any_instance.stub(:save).and_return(false)
          put :update, {id: @item.to_param, item: {}}
          expect(assigns(:item)).to eq(@item)
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
        expect(response).to redirect_to(admin_items_url)
      end
    end
    
  end
end
