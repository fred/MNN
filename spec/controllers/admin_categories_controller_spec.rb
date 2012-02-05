require 'spec_helper'

describe Admin::CategoriesController do
  
  describe "Not Logged in users" do
    describe "GET index" do
      it "redirects to the login page" do
        get :index
        response.should redirect_to(new_admin_user_session_path)
      end
    end
  end
  
  describe "Logged in users" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = Factory(:admin_user)
      @role = Factory(:role_admin)
      @user.roles << @role
      sign_in @user
    end
    
    describe "Existing Category" do
      before (:each) do
        @category = Factory(:category)
      end
      describe "GET index" do
        it "Should Show @categories array" do
          get :index
          assigns(:categories).should eq([@category])
        end
      end
      describe "GET show" do
        it "Should Show @category" do
          get :show, :id => @category.id
          assigns(:category).should eq(@category)
        end
      end
      describe "GET edit" do
        it "Should have @category" do
          get :edit, :id => @category.id
          assigns(:category).should eq(@category)
        end
        it "Should have @category not as new record" do
          get :edit, :id => @category.id
          assigns(:category).should_not be_new_record
        end
      end
    end

    describe "New Category Record" do
      describe "GET new" do
        it "Should show new category page" do
          get :new
          assigns(:category).should_not be_nil
        end
        it "Should show new category page" do
          get :new
          assigns(:category).should be_new_record
        end
      end
    end
    
  end
end
