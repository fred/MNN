require 'spec_helper'

describe Devise::RegistrationsController do
  include Devise::TestHelpers
  include UserSpecHelper
  
  describe "A Guest AdminUser" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
    end
    describe "GET new" do
      it "should be successful" do
        get :new
        expect(response).to be_success
      end
      it "should have admin_user as a new object" do
        get :new
        expect(assigns(:admin_user)).to be_a_new(AdminUser)
      end
      it "should stub a new admin_user object" do
        get :new
        expect(assigns(:admin_user)).not_to be_nil
      end
    end
  end
  
  
  describe "A Logged in User" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      sign_in @user
    end
    describe "GET edit" do
      it "should be successful" do
        get :edit
        expect(response).to be_success
      end
      it "should have current_admin_user not nil" do
        get :edit
        expect(subject.current_admin_user).not_to be_nil
      end
      it "should assign current_admin_user as a the admin_user object" do
        get :edit
        expect(assigns(:admin_user)).to eq(subject.current_admin_user)
      end
    end
  end
  
  
  
  describe "POST create" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
    end
    
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, admin_user: valid_user_attributes
        }.to change(AdminUser, :count).by(1)
      end
  
      it "assigns a newly created user as @admin_user" do
        post :create, admin_user: valid_user_attributes
        expect(assigns(:admin_user)).to be_a(AdminUser)
        expect(assigns(:admin_user)).to be_persisted
      end
        
      it "redirects to the admin_dashboard after creating admin_user" do
        post :create, admin_user: valid_user_attributes
        expect(response).to redirect_to(root_path)
      end
      
      it "assigns current_user to the newly created admin_user" do
        post :create, admin_user: valid_user_attributes
        expect(subject.current_admin_user).not_to be_nil
      end
    end
  
    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @admin_user" do
        post :create, admin_user: {}
        expect(assigns(:admin_user)).to be_a_new(AdminUser)
      end
  
      it "re-renders the 'new' template" do
        post :create, admin_user: {}
        expect(response).to render_template("new")
      end
    end
  end
  
  
end
