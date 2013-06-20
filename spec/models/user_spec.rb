require 'spec_helper'

describe User do
  include UserSpecHelper
  describe "Validity" do 
    before(:each) do
      @user = FactoryGirl.build(:user)
      @user.confirm!
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
      expect(@user.is_admin?).to eq(false)
    end
    it "should allow to Upgrade user" do
      @user.upgrade = "1"
      @user.save
      expect(@user.is_admin?).to eq(true)
    end
    it "should have the user title" do
      @user.name = "joe"
      expect(@user.title).to eq(@user.name)
    end
    it "should have the user public display_name" do
      @user.name = nil
      expect(@user.public_display_name).to match(/Anonymous/)
    end
  end

  describe "User Security" do
    let(:role){
      Role.create title: 'test-role'
    }
    let(:user){
      User.new(
        email: "welcome@gmail.com",
        name: 'My Name',
        password: 'welcome',
        password_confirmation: 'welcome'
      )
    }
    it "should not allow new users to self upgrade" do
      user.mark_as_confirmed
      user.upgrade = true
      expect(user.valid?).to eq(false)
      expect(user.errors.size).to be(1)
      user.upgrade = nil
    end
    it "should not allow new users to add roles" do
      user.role_ids = [role.id]
      expect(user.valid?).to eq(false)
      expect(user.errors.size).to be(1)
    end
    it "should allow new users to register if no escalation is detected" do
      user.role_ids = []
      user.upgrade = nil
      expect(user.valid?).to eq(true)
      expect(user.errors.size).to be(0)
    end
  end

  
  describe "Instance Methods" do
    let(:user){
      stub_model(User,
        email: "welcome@gmail.com",
        name: 'My Name',
        password: 'welcome',
        password_confirmation: 'welcome',
        confirmation_token: nil,
        confirmed_at: Time.now
      )
    }
    it "should respond to notify_admin" do
      expect(user).to respond_to(:notify_admin)
    end
    it "should respond to send_welcome_email" do
      expect(user).to respond_to(:send_welcome_email)
    end
    it "should respond to check_upgrade" do
      expect(user).to respond_to(:check_upgrade)
    end
    it "should respond to original_items_count" do
      expect(user).to respond_to(:original_items_count)
    end
    it "should respond to is_admin?" do
      expect(user).to respond_to(:is_admin?)
    end
    it "should respond to title" do
      expect(user).to respond_to(:title)
    end
    it "should respond to public_display_name" do
      expect(user).to respond_to(:public_display_name)
    end
    it "should respond to has_image?" do
      expect(user).to respond_to(:has_image?)
    end
    it "should respond to main_image" do
      expect(user).to respond_to(:main_image)
    end
    it "should respond to has_role?(role_sym)" do
      expect(user).to respond_to(:has_role?)
    end
    it "should respond to has_any_role?" do
      expect(user).to respond_to(:has_any_role?)
    end
    it "should respond to role_titles" do
      expect(user).to respond_to(:role_titles)
    end
    it "should respond to role_models" do
      expect(user).to respond_to(:role_models)
    end
    it "should respond to has_subscription?" do
      expect(user).to respond_to(:has_subscription?)
    end
    it "should respond to create_subscriptions" do
      expect(user).to respond_to(:create_subscriptions)
    end
    it "should respond to update_subscriptions" do
      expect(user).to respond_to(:update_subscriptions)
    end
    it "should respond to cancel_subscriptions" do
      expect(user).to respond_to(:cancel_subscriptions)
    end
    it "should respond to my_items" do
      expect(user).to respond_to(:my_items)
    end
    it "should respond to twitter_username" do
      expect(user).to respond_to(:twitter_username)
    end
  end

  describe "Class Methods" do
    it "should respond to find_or_create_from_oauth" do
      expect(User).to respond_to(:find_or_create_from_oauth)
    end
    it "should respond to facebook_oauth" do
      expect(User).to respond_to(:facebook_oauth)
    end
    it "should respond to twitter_oauth" do
      expect(User).to respond_to(:twitter_oauth)
    end
    it "should respond to flattr_oauth" do
      expect(User).to respond_to(:flattr_oauth)
    end
    it "should respond to google_oauth" do
      expect(User).to respond_to(:google_oauth)
    end
    it "should respond to linkedin_oauth" do
      expect(User).to respond_to(:linkedin_oauth)
    end
    it "should respond to windowslive_oauth" do
      expect(User).to respond_to(:windowslive_oauth)
    end
    it "should respond to popular" do
      expect(User).to respond_to(:popular)
    end
    it "should respond to admin_users" do
      expect(User).to respond_to(:admin_users)
    end
    it "should respond to security_users" do
      expect(User).to respond_to(:security_users)
    end
    it "should respond to approved" do
      expect(User).to respond_to(:approved)
    end
    it "should respond to pending" do
      expect(User).to respond_to(:pending)
    end
    it "should respond to recent" do
      expect(User).to respond_to(:recent)
    end
    it "should respond to recent_pending" do
      expect(User).to respond_to(:recent_pending)
    end
    it "should respond to logged_in" do
      expect(User).to respond_to(:logged_in)
    end
  end
  
  describe "with subscription" do
    before(:each) do
      @user = FactoryGirl.build(:user, subscribe: "1")
      @user.confirm!
    end
    it "should create a subscription model" do
      expect(@user.subscriptions).not_to eq([])
      expect(@user.subscriptions.last).to eq(Subscription.first)
    end
    it "should create a subscription with the user email" do
      @subscription = @user.subscriptions.last
      expect(@subscription.email).to eq(@user.email)
    end
    it "should delete the user subscription when unsubscribed" do
      @user.subscribe = nil
      @user.unsubscribe = "1"
      @user.save
      expect(@user.subscriptions).to eq([])
    end
    it "should delete the user subscription when unsubscribe_all" do
      @user.unsubscribe_all = "1"
      @user.subscribe = nil
      @user.save
      expect(@user.subscriptions).to eq([])
      expect(@user.subscriptions.count).to eq(0)
    end
    it "should update the user subscription email when saving user" do
      @user.email = "123456@new_email.com"
      @user.save
      expect(@user.subscriptions.last.email).to eq(@user.email)
    end
  end
  
  describe "with unsubscribe or unsubscribe_all" do
    before(:each) do
      @user = FactoryGirl.build(:user, unsubscribe: "1")
      @user.confirm!
    end
    it "should not create a subscription" do
      expect(@user.subscriptions).to eq([])
      expect(@user.subscriptions.count).to eq(0)
    end
    it "should delete the user subscription when unsubscribe_all" do
      @user.unsubscribe_all = "1"
      @user.subscribe = nil
      @user.save
      expect(@user.subscriptions).to eq([])
      expect(@user.subscriptions.count).to eq(0)
    end
    it "should create the user subscription when subscribed" do
      @user.unsubscribe = nil
      @user.subscribe = "1"
      @user.save
      expect(@user.subscriptions).not_to eq([])
    end
    it "should update the user email but not create subscription" do
      @user.email = "123456@new_email.com"
      @user.save
      expect(@user.subscriptions).to eq([])
    end
  end

  describe "with email notifications" do
    it 'should send Confirmation email, Welcome email and Admin notification email' do
      expect(->{ 
        user = FactoryGirl.build(:user)
        user.confirm!
      }).to change(ActionMailer::Base.deliveries, :count).by(3)
    end
    it 'should not send Welcome email to User logged in from Twitter' do
      expect(->{
        user = FactoryGirl.build(:user, provider: 'twitter', oauth_data: {info: "test-info"})
        user.confirm!
      }).to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
  
end
