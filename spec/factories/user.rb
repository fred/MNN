FactoryGirl.define do
  
  factory :user, class: "User" do
    name 'User'
    email  'user@email.com'
    password 'welcome'
    password_confirmation 'welcome'
  end
  
  factory :user2, class: "User" do
    name 'User 2'
    email  'user2@email.com'
    password 'welcome'
    password_confirmation 'welcome'
  end
  
  factory :admin_user, class: "AdminUser" do
    name 'Admin User'
    email  'admin@email.com'
    password 'welcome'
    password_confirmation 'welcome'
  end

  factory :user_with_gpg, class: 'User' do
    name 'my name'
    email  'gpg@email.com'
    password 'welcome'
    password_confirmation 'welcome'

    gpg { 
      fixture_file_upload "#{Rails.root}/public/robots.txt", 'text'
    }
    to_create do |instance|
      instance.save!(validate: false)
    end
  end
  
end
