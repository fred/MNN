require 'spec_helper'

describe Devise::SessionsController do
  include Devise::TestHelpers

  describe "A Guest User" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    describe "GET new" do
      it "should be successful" do
        get :new
        response.should be_success
      end
    end
  end
  
  describe "A Normal User" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = Factory(:user)
    end
    describe "POST create" do
      it "should login user and redirect to root_path" do
        post :create, {:user => {:email => @user.email, :password => "welcome"}}
        response.should redirect_to(root_path)
      end
      it "should login user and assign current_user" do
        post :create, {:user => {:email => @user.email, :password => "welcome"}}
        subject.current_user.should_not be_nil
      end
    end
  end

end