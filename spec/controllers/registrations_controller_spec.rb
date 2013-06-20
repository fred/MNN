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
        expect(response).to be_success
      end
      it "should have user as a new object" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
      it "should stub a new user object" do
        get :new
        expect(assigns(:user)).not_to be_nil
      end
    end
  end
  
  
  describe "A Logged in User" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      @user.confirm!
      sign_in @user
    end
    describe "GET edit" do
      it "should be successful" do
        get :edit
        expect(response).to be_success
      end
      it "should have current_user not nil" do
        get :edit
        expect(subject.current_user).not_to be_nil
      end
      it "should have current user as a the user object" do
        get :edit
        expect(assigns(:user)).to eq(subject.current_user)
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
          post :create, user: valid_user_attributes
        }.to change(User, :count).by(1)
      end
  
      it "assigns a newly created user as @user" do
        post :create, user: valid_user_attributes
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end
        
      it "redirects to the created user" do
        post :create, user: valid_user_attributes
        expect(response).to redirect_to(root_path)
      end
      
      it "do not assign current_user to the newly created user" do
        post :create, user: valid_user_attributes
        expect(subject.current_user).to be_nil
      end
    end
  
    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        post :create, user: {}
        expect(assigns(:user)).to be_a_new(User)
      end
  
      it "re-renders the 'new' template" do
        post :create, user: {}
        expect(response).to render_template("new")
      end
    end

    describe "with security breaches" do
      it "should not let user self upgrade" do
        post :create, user: valid_user_attributes.merge(upgrade: true)
        expect(assigns(:user)).to be_a_new(User)
      end
  
      it "should not let user self add roles" do
        role = Role.create(title: 'I-wanna-be-admin')
        post :create, user: valid_user_attributes.merge(role_ids: [role.id])
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
  
  
end