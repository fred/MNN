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
      it "assigns a new page as @page" do
        get :new
        assigns(:page).should be_a_new(Page)
      end
    end
    
    describe "GET edit" do
      it "assigns the requested page as @page" do
        page = Page.create! valid_attributes
        get :edit, {id: page.to_param}
        assigns(:page).should eq(page)
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
          assigns(:page).should be_a(Page)
          assigns(:page).should be_persisted
        end
    
        it "redirects to the created page" do
          post :create, {page: valid_attributes}
          response.should redirect_to(admin_page_path(Page.last))
        end
      end

      # describe "with invalid params" do
      #   it "assigns a newly created but unsaved page as @page" do
      #     # Trigger the behavior that occurs when invalid params are submitted
      #     Page.any_instance.stub(:save).and_return(false)
      #     post :create, {page: {}}
      #     assigns(:page).should be_a_new(Page)
      #   end
    
      #   it "re-renders the 'new' template" do
      #     # Trigger the behavior that occurs when invalid params are submitted
      #     Page.any_instance.stub(:save).and_return(false)
      #     post :create, {page: {}}
      #     response.should render_template("new")
      #   end
      # end
    end

    describe "PUT update" do
      describe "with valid params" do

        # it "updates the requested page" do
        #   page = Page.create! valid_attributes
        #   Page.any_instance.should_receive(:update_attributes).with({'title' => 'hello'})
        #   put :update, {id: page.to_param, page: {'title' => 'hello'}}
        # end
    
        it "assigns the requested page as @page" do
          page = Page.create! valid_attributes
          put :update, {id: page.to_param, page: valid_attributes}
          assigns(:page).should eq(page)
        end
    
        it "redirects to the page" do
          page = Page.create! valid_attributes
          put :update, {id: page.to_param, page: valid_attributes}
          response.should redirect_to(admin_page_path(page))
        end
      end

      describe "with invalid params" do
        it "assigns the page as @page" do
          page = Page.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Page.any_instance.stub(:save).and_return(false)
          put :update, {id: page.to_param, page: {}}
          assigns(:page).should eq(page)
        end

        # it "re-renders the 'edit' template" do
        #   page = Page.create! valid_attributes
        #   # Trigger the behavior that occurs when invalid params are submitted
        #   Page.any_instance.stub(:save).and_return(false)
        #   put :update, {id: page.to_param, page: {}}
        #   response.should render_template("edit")
        # end
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
        response.should redirect_to(admin_pages_url)
      end
    end

  end
end
