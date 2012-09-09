require 'spec_helper'

describe Admin::ItemsController do
  include ItemSpecHelper

  describe "Logged in as an Admin" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_admin)
      @user.roles << @role
      @item = FactoryGirl.create(:item, user_id: @user.id)
      sign_in @user
    end
    describe "deleting own live article" do
      it "should be allowed" do
        expect {
          delete :destroy, {id: @item.to_param}
        }.to change(Item, :count).by(-1)
      end
    end
    describe "editing own live article" do
      it "should be allowed" do
        get :edit, id: @item.id
        expect(assigns(:item)).to eq(@item)
      end
    end
    describe "updating own live article" do
      it "should be allowed" do
        put :update, {id: @item.to_param, item: {title: 'new title'}}
        expect(response).to redirect_to(assigns(:item))
      end
    end
  end

  describe "Logged in as an Editor" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_editor)
      @user.roles << @role
      @item = FactoryGirl.create(:item, user_id: @user.id)
      sign_in @user
    end
    describe "deleting own live article" do
      it "should be allowed" do
        expect {
          delete :destroy, {id: @item.to_param}
        }.to change(Item, :count).by(-1)
      end
    end
    describe "editing own live article" do
      it "should be allowed" do
        get :edit, id: @item.id
        expect(assigns(:item)).to eq(@item)
      end
    end
    describe "updating own live article" do
      it "should be allowed" do
        put :update, {id: @item.to_param, item: {title: 'new title'}}
        expect(response).to redirect_to(assigns(:item))
      end
    end
  end

  describe "Logged in as an Author" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_author)
      @user.roles << @role
      @item = FactoryGirl.create(:item, user_id: @user.id)
      sign_in @user
    end
    describe "deleting own live article" do
      it "should not be allowed" do
        expect {
          delete :destroy, {id: @item.to_param}
        }.to change(Item, :count).by(0)
      end
    end
    describe "editing own live article" do
      it "should not be allowed" do
        get :edit, id: @item.id
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end
    describe "updating own live article" do
      it "should not be allowed" do
        put :update, {id: @item.to_param, item: {title: 'new title'}}
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end
  end


  describe "Logged in as a basic user" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_basic)
      @user.roles << @role
      @item = FactoryGirl.create(:item, user_id: @user.id)
      sign_in @user
    end
    describe "deleting own live article" do
      it "should not be allowed" do
        expect {
          delete :destroy, {id: @item.to_param}
        }.to change(Item, :count).by(0)
      end
    end
    describe "editing own live article" do
      it "should not be allowed" do
        get :edit, id: @item.id
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end
    describe "updating own live article" do
      it "should not be allowed" do
        put :update, {id: @item.to_param, item: {title: 'new title'}}
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end
  end

end