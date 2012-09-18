require 'spec_helper'

describe Admin::PagesController do
  
  describe "Not Logged in users" do
    describe "GET index" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end
  end
  
  describe "Logged in users" do

    # This should return the minimal set of attributes required to create a valid
    # Page. As you add validations to Page, be sure to
    # update the return value of this method accordingly.
    def valid_attributes
      {title: "title text", body: "body text"}
    end

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @user = FactoryGirl.create(:admin_user)
      @role = FactoryGirl.create(:role_admin)
      @user.roles << @role
      sign_in @user
    end

    describe "Existing Page" do
      before (:each) do
        @page = FactoryGirl.create(:page)
        @page_two = FactoryGirl.create(:page_two)
      end
      describe "GET index" do
        it "Should Show @pages array" do
          get :index
          expect(assigns(:pages)).to eq(Page.order("updated_at DESC").all)
        end
      end
      describe "GET show" do
        it "Should Show @page" do
          get :show, id: @page.id
          expect(assigns(:page)).to eq(@page)
        end
      end
      describe "GET edit" do
        it "Should have @page" do
          get :edit, id: @page.id
          expect(assigns(:page)).to eq(@page)
        end
        it "Should have @page not as new record" do
          get :edit, id: @page.id
          expect(assigns(:page)).not_to be_new_record
        end
      end
    end

    describe "New Page Record" do
      describe "GET new" do
        it "Should show new page page" do
          get :new
          expect(assigns(:page)).not_to be_nil
        end
        it "Should show new page page" do
          get :new
          expect(assigns(:page)).to be_new_record
        end
      end
      it "assigns a new page as @page" do
        get :new
        expect(assigns(:page)).to be_a_new(Page)
      end
    end
    
    describe "GET edit" do
      it "assigns the requested page as @page" do
        page = Page.create! valid_attributes
        get :edit, {id: page.to_param}
        expect(assigns(:page)).to eq(page)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Page" do
          expect {
            post :create, {page: valid_attributes}
          }.to change(Page, :count).by(1)
        end
    
        it "assigns a newly created page as @page" do
          post :create, {page: valid_attributes}
          expect(assigns(:page)).to be_a(Page)
          expect(assigns(:page)).to be_persisted
        end
    
        it "redirects to the created page" do
          post :create, {page: valid_attributes}
          expect(response).to redirect_to(admin_page_path(Page.last))
        end
      end

    end

    describe "PUT update" do
      describe "with valid params" do
    
        it "assigns the requested page as @page" do
          page = Page.create! valid_attributes
          put :update, {id: page.to_param, page: valid_attributes}
          expect(assigns(:page)).to eq(page)
        end
    
        it "redirects to the page" do
          page = Page.create! valid_attributes
          put :update, {id: page.to_param, page: valid_attributes}
          expect(response).to redirect_to(admin_page_path(page))
        end
      end

      describe "with invalid params" do
        it "assigns the page as @page" do
          page = Page.create! valid_attributes
          Page.any_instance.stub(:save).and_return(false)
          put :update, {id: page.to_param, page: {}}
          expect(assigns(:page)).to eq(page)
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested page" do
        page = Page.create! valid_attributes
        expect {
          delete :destroy, {id: page.to_param}
        }.to change(Page, :count).by(-1)
      end

      it "redirects to the pages list" do
        page = Page.create! valid_attributes
        delete :destroy, {id: page.to_param}
        expect(response).to redirect_to(admin_pages_url)
      end
    end

  end
end
