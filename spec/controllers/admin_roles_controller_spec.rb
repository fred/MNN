# require 'spec_helper'
# 
# describe Admin::ItemsController do
#   
#   describe "Not Logged in users" do
#     describe "GET index" do
#       it "redirects to the login page" do
#         get :index
#         response.should redirect_to(new_admin_user_session_path)
#       end
#     end
#   end
#   
#   describe "Logged in users" do
#     before (:each) do
#       @request.env["devise.mapping"] = Devise.mappings[:admin_user]
#       @user = Factory(:admin_user)
#       @role = Factory(:role_admin)
#       @user.roles << @role
#       sign_in @user
#     end
#     
#     describe "Existing Item" do
#       before (:each) do
#         @item = Factory(:item)
#       end
#       describe "GET index" do
#         it "Should Show @items array" do
#           get :index
#           assigns(:items).should eq([@item])
#         end
#       end
#       describe "GET show" do
#         it "Should Show @item" do
#           get :show, :id => @item.id
#           assigns(:item).should eq(@item)
#         end
#       end
#       describe "GET edit" do
#         it "Should have @item" do
#           get :edit, :id => @item.id
#           assigns(:item).should eq(@item)
#         end
#         it "Should have @item not as new record" do
#           get :edit, :id => @item.id
#           assigns(:item).should_not be_new_record
#         end
#       end
#     end
# 
#     describe "New Item Record" do
#       describe "GET new" do
#         it "Should show new item page" do
#           get :new
#           assigns(:item).should_not be_nil
#         end
#         it "Should show new item page" do
#           get :new
#           assigns(:item).should be_new_record
#         end
#       end
#     end
#     
#   end
# end
