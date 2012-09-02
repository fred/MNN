require 'spec_helper'

describe Admin::ItemStatsController do
  
  describe "Not Logged in users" do
    describe "GET index" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end
  end
  
  describe "Logged in users" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_admin)
      @user.roles << @role
      sign_in @user
    end
    
    describe "GET index" do
      it "Should show empty array" do
        get :index
        expect(assigns(:item_stats)).to eq([])
      end
      
      it "Should have one item_stat in the array" do
        @item = FactoryGirl.create(:item)
        get :index
        expect(assigns(:item_stats)).to eq([@item.item_stat])
      end
      
    end
    
  end
end
