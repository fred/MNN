require 'spec_helper'

describe Admin::PagesController do
  
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
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_admin)
      @user.roles << @role
      sign_in @user
    end
    
    describe "Existing Page" do
      before (:each) do
        @page = FactoryGirl.create(:page)
      end
      describe "GET index" do
        it "Should Show @pages array" do
          get :index
          assigns(:pages).should eq([@page])
        end
      end
      describe "GET show" do
        it "Should Show @page" do
          get :show, id: @page.id
          assigns(:page).should eq(@page)
        end
      end
      describe "GET edit" do
        it "Should have @page" do
          get :edit, id: @page.id
          assigns(:page).should eq(@page)
        end
        it "Should have @page not as new record" do
          get :edit, id: @page.id
          assigns(:page).should_not be_new_record
        end
      end
    end

    describe "New Page Record" do
      describe "GET new" do
        it "Should show new page page" do
          get :new
          assigns(:page).should_not be_nil
        end
        it "Should show new page page" do
          get :new
          assigns(:page).should be_new_record
        end
      end
    end
    
  end
end
