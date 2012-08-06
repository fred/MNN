require 'spec_helper'

describe User do
  include UserSpecHelper
  describe "Validity" do 
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it "should be valid" do
      assert_equal true, @user.valid?
    end
    it "should require a email" do
      @user.email = nil
      assert_equal false, @user.valid?
    end
    it "should require a valid email" do
      @user.email = "mail@mail"
      assert_equal false, @user.valid?
      @user.email = "abcd@abcd"
      assert_equal false, @user.valid?
      @user.email = "a@b.co"
      assert_equal true, @user.valid?
      @user.email = "a@bo.c"
      assert_equal true, @user.valid?
      @user.email = "a@b.co"
      assert_equal true, @user.valid?
    end
    it "should not allow name password same as name" do
      @user.name = "welcome"
      @user.password = "welcome"
      @user.password_confirmation = "welcome"
      assert_equal false, @user.valid?
    end
    it "should return false on is_admin?" do
      @user.is_admin?.should eq(false)
    end
    it "should allow to Upgrade user" do
      @user.upgrade = "1"
      @user.save
      @user.is_admin?.should eq(true)
    end
    it "should have the user title" do
      @user.name = "joe"
      @user.title.should eq(@user.name)
    end
    it "should have the user public display_name" do
      @user.name = nil
      @user.public_display_name.should match(/Anonymous/)
    end
  end
  
  describe "Instance Methods" do
    let(:user){
      stub_model(User,
        email: "welcome@gmail.com",
        name: 'My Name',
        password: 'welcome',
        password_confirmation: 'welcome'
      )
    }
    it "should respond to notify_admin" do
      user.should respond_to(:notify_admin)
    end
    it "should respond to send_welcome_email" do
      user.should respond_to(:send_welcome_email)
    end
    it "should respond to check_upgrade" do
      user.should respond_to(:check_upgrade)
    end
    it "should respond to original_items_count" do
      user.should respond_to(:original_items_count)
    end
    it "should respond to is_admin?" do
      user.should respond_to(:is_admin?)
    end
    it "should respond to title" do
      user.should respond_to(:title)
    end
    it "should respond to public_display_name" do
      user.should respond_to(:public_display_name)
    end
    it "should respond to has_image?" do
      user.should respond_to(:has_image?)
    end
    it "should respond to main_image" do
      user.should respond_to(:main_image)
    end
    it "should respond to has_role?(role_sym)" do
      user.should respond_to(:has_role?)
    end
    it "should respond to has_any_role?" do
      user.should respond_to(:has_any_role?)
    end
    it "should respond to role_titles" do
      user.should respond_to(:role_titles)
    end
    it "should respond to role_models" do
      user.should respond_to(:role_models)
    end
    it "should respond to has_subscription?" do
      user.should respond_to(:has_subscription?)
    end
    it "should respond to create_subscriptions" do
      user.should respond_to(:create_subscriptions)
    end
    it "should respond to update_subscriptions" do
      user.should respond_to(:update_subscriptions)
    end
    it "should respond to cancel_subscriptions" do
      user.should respond_to(:cancel_subscriptions)
    end
    it "should respond to my_items" do
      user.should respond_to(:my_items)
    end
    it "should respond to twitter_username" do
      user.should respond_to(:twitter_username)
    end
  end

  describe "Class Methods" do
    it "should respond to find_or_create_from_oauth" do
      User.should respond_to(:find_or_create_from_oauth)
    end
    it "should respond to facebook_oauth" do
      User.should respond_to(:facebook_oauth)
    end
    it "should respond to twitter_oauth" do
      User.should respond_to(:twitter_oauth)
    end
    it "should respond to flattr_oauth" do
      User.should respond_to(:flattr_oauth)
    end
    it "should respond to google_oauth" do
      User.should respond_to(:google_oauth)
    end
    it "should respond to linkedin_oauth" do
      User.should respond_to(:linkedin_oauth)
    end
    it "should respond to windowslive_oauth" do
      User.should respond_to(:windowslive_oauth)
    end
    it "should respond to popular" do
      User.should respond_to(:popular)
    end
    it "should respond to admin_users" do
      User.should respond_to(:admin_users)
    end
    it "should respond to security_users" do
      User.should respond_to(:security_users)
    end
    it "should respond to approved" do
      User.should respond_to(:approved)
    end
    it "should respond to pending" do
      User.should respond_to(:pending)
    end
    it "should respond to recent" do
      User.should respond_to(:recent)
    end
    it "should respond to recent_pending" do
      User.should respond_to(:recent_pending)
    end
    it "should respond to logged_in" do
      User.should respond_to(:logged_in)
    end
  end
  
  describe "with subscription" do
    before(:each) do
      @user = FactoryGirl.create(:user, subscribe: "1")
    end
    it "should create a subscription model" do
      @user.subscriptions.should_not eq([])
      @user.subscriptions.last.should eq(Subscription.first)
    end
    it "should create a subscription with the user email" do
      @subscription = @user.subscriptions.last
      @subscription.email.should eq(@user.email)
    end
    it "should delete the user subscription when unsubscribed" do
      @user.subscribe = nil
      @user.unsubscribe = "1"
      @user.save
      @user.subscriptions.should eq([])
    end
    it "should delete the user subscription when unsubscribe_all" do
      @user.unsubscribe_all = "1"
      @user.subscribe = nil
      @user.save
      @user.subscriptions.should eq([])
      @user.subscriptions.count.should eq(0)
    end
    it "should update the user subscription email when saving user" do
      @user.email = "123456@new_email.com"
      @user.save
      @user.subscriptions.last.email.should eq(@user.email)
    end
  end
  
  describe "with unsubscribe or unsubscribe_all" do
    before(:each) do
      @user = FactoryGirl.create(:user, unsubscribe: "1")
    end
    it "should not create a subscription" do
      @user.subscriptions.should eq([])
      @user.subscriptions.count.should eq(0)
    end
    it "should delete the user subscription when unsubscribe_all" do
      @user.unsubscribe_all = "1"
      @user.subscribe = nil
      @user.save
      @user.subscriptions.should eq([])
      @user.subscriptions.count.should eq(0)
    end
    it "should create the user subscription when subscribed" do
      @user.unsubscribe = nil
      @user.subscribe = "1"
      @user.save
      @user.subscriptions.should_not eq([])
    end
    it "should update the user email but not create subscription" do
      @user.email = "123456@new_email.com"
      @user.save
      @user.subscriptions.should eq([])
    end
  end

  describe "with email notifications" do
    it 'should send an Welcome email to the User and to Admin' do
      ->{ FactoryGirl.create(:user) }.should change(ActionMailer::Base.deliveries, :count).by(2)
    end
  end
  
end
