require 'spec_helper'

describe Devise::RegistrationsController do
  include Devise::TestHelpers
  include UserSpecHelper
  
  describe "A Guest User" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    describe "GET new" do
      it "should be successful" do
        get :new
        response.should be_success
      end
      it "should have user as a new object" do
        get :new
        assigns(:user).should be_a_new(User)
      end
      it "should stub a new user object" do
        get :new
        assigns(:user).should_not be_nil
      end
    end
  end
  
  
  describe "A Logged in User" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
    describe "GET edit" do
      it "should be successful" do
        get :edit
        response.should be_success
      end
      it "should have current_user not nil" do
        get :edit
        subject.current_user.should_not be_nil
      end
      it "should have current user as a the user object" do
        get :edit
        assigns(:user).should eq(subject.current_user)
      end
    end
  end
  
  
  
  describe "POST create" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, :user => valid_user_attributes
        }.to change(User, :count).by(1)
      end
  
      it "assigns a newly created user as @user" do
        post :create, :user => valid_user_attributes
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end
        
      it "redirects to the created user" do
        post :create, :user => valid_user_attributes
        response.should redirect_to(root_path)
      end
      
      it "assigns current_user to the newly created user" do
        post :create, :user => valid_user_attributes
        subject.current_user.should_not be_nil
      end
    end
  
    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, :user => {}
        assigns(:user).should be_a_new(User)
      end
  
      it "re-renders the 'new' template" do
        post :create, :user => {}
        response.should render_template("new")
      end
    end
  end
  
  
end