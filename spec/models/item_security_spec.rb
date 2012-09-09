require 'spec_helper'

describe Item do
  include ItemSpecHelper

  describe "Updating" do

    describe "as an admin" do
      before(:each) do
        @user = FactoryGirl.create(:admin_user)
        @role = FactoryGirl.create(:role_admin)
        @user.roles << @role
        @item = FactoryGirl.create(:item, user_id: @user.id, draft: false)
      end
      it "should be allowed for published item" do
        @item.title = "new title"
        @item.updating_user_id = @user.id
        expect{@item.save}.not_to raise_error
      end
    end

    describe "as an editor" do
      before(:each) do
        @user = FactoryGirl.create(:admin_user)
        @role = FactoryGirl.create(:role_editor)
        @user.roles << @role
        @item = FactoryGirl.create(:item, user_id: @user.id, draft: false)
      end
      it "should be allowed for published item" do
        @item.title = "new title"
        @item.updating_user_id = @user.id
        expect{@item.save}.not_to raise_error
      end
    end

    describe "as an author" do
      before(:each) do
        @user = FactoryGirl.create(:admin_user)
        @role = FactoryGirl.create(:role_author)
        @user.roles << @role
        @item = FactoryGirl.create(:item, user_id: @user.id, draft: false)
      end
      it "should not be allowed for published item" do
        @item.title = "new title"
        @item.updating_user_id = @user.id
        expect{@item.save}.not_to raise_error
      end
    end

    describe "as a basic admin" do
      before(:each) do
        @user = FactoryGirl.create(:admin_user)
        @role = FactoryGirl.create(:role_basic)
        @user.roles << @role
        @item = FactoryGirl.create(:item, user_id: @user.id, draft: false)
      end
      it "should not be allowed for published item" do
        @item.title = "new title"
        @item.updating_user_id = @user.id
        expect{@item.save}.not_to raise_error
      end
    end

    describe "as a user" do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @item = FactoryGirl.create(:item, user_id: @user.id, draft: false)
      end
      it "should not be allowed for published item" do
        @item.title = "new title"
        @item.updating_user_id = @user.id
        expect{@item.save}.not_to raise_error
      end
    end


  end

end
