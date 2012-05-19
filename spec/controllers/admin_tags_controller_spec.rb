# require 'spec_helper'

# describe Admin::TagsController do
  
#   describe "Not Logged in users" do
#     describe "GET index" do
#       it "redirects to the login page" do
#         get :index
#         response.should redirect_to(new_admin_user_session_path)
#       end
#     end
#   end
  
#   describe "Logged in users" do
#     before (:each) do
#       @request.env["devise.mapping"] = Devise.mappings[:admin_user]
#       @user = FactoryGirl.create(:admin_user)
#       @role = FactoryGirl.create(:role_admin)
#       @user.roles << @role
#       sign_in @user
#     end
    
#     describe "Existing Tag" do
#       before (:each) do
#         @tag = FactoryGirl.create(:tag)
#       end
#       describe "GET index" do
#         it "Should Show @tags array" do
#           get :index
#           assigns(:tags).should eq([@tag])
#         end
#       end
#       describe "GET show" do
#         it "Should Show @tag" do
#           get :show, id: @tag.id
#           assigns(:tag).should eq(@tag)
#         end
#       end
#       describe "GET edit" do
#         it "Should have @tag" do
#           get :edit, id: @tag.id
#           assigns(:tag).should eq(@tag)
#         end
#         it "Should have @tag not as new record" do
#           get :edit, id: @tag.id
#           assigns(:tag).should_not be_new_record
#         end
#       end
#     end

#     describe "New Tag Record" do
#       describe "GET new" do
#         it "Should show new tag page" do
#           get :new
#           assigns(:tag).should_not be_nil
#         end
#         it "Should show new tag page" do
#           get :new
#           assigns(:tag).should be_new_record
#         end
#       end
#     end
    
#   end
# end
