require 'spec_helper'

describe Admin::UsersController do
  
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
    
    describe "Existing User" do
      # before (:each) do
      #   @user = FactoryGirl.create(:user)
      # end
      describe "GET index" do
        it "Should Show @users array" do
          get :index
          expect(assigns(:users)).to eq([@user])
        end
      end
      describe "GET show" do
        it "Should Show @user" do
          get :show, id: @user.id
          expect(assigns(:user)).to eq(@user)
        end
      end
      describe "GET edit" do
        it "Should have @user" do
          get :edit, id: @user.id
          expect(assigns(:user)).to eq(@user)
        end
        it "Should have @user not as new record" do
          get :edit, id: @user.id
          expect(assigns(:user)).not_to be_new_record
        end
      end
    end

    describe "New User Record" do
      describe "GET new" do
        it "Should show new user page" do
          get :new
          expect(assigns(:user)).not_to be_nil
        end
        it "Should show new user page" do
          get :new
          expect(assigns(:user)).to be_new_record
        end
      end
    end
    
  end
end
