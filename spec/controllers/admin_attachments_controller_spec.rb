require 'spec_helper'

describe Admin::AttachmentsController do
  
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
    
    describe "Existing Attachment" do
      before (:each) do
        @attachment = FactoryGirl.create(:attachment)
      end
      describe "GET index" do
        it "Should Show @attachments array" do
          get :index
          expect(assigns(:attachments)).to eq([@attachment])
        end
      end
      describe "GET show" do
        it "Should Show @attachment" do
          get :show, id: @attachment.id
          expect(assigns(:attachment)).to eq(@attachment)
        end
      end
      describe "GET edit" do
        it "Should have @attachment" do
          get :edit, id: @attachment.id
          expect(assigns(:attachment)).to eq(@attachment)
        end
        it "Should have @attachment not as new record" do
          get :edit, id: @attachment.id
          expect(assigns(:attachment)).not_to be_new_record
        end
      end
    end

    describe "New Attachment Record" do
      describe "GET new" do
        it "Should show new attachment page" do
          get :new
          expect(assigns(:attachment)).not_to be_nil
        end
        it "Should show new attachment page" do
          get :new
          expect(assigns(:attachment)).to be_new_record
        end
      end
    end
    
  end
end
