FactoryGirl.define do
  
  factory :user, class: "User" do
    name 'User'
    sequence(:email){|n| "user#{n}@email.com" }
    password 'welcome'
    password_confirmation 'welcome'
  end
  
  factory :user2, class: "User" do
    name 'User 2'
    sequence(:email){|n| "user2#{n}@email.com" }
    password 'welcome'
    password_confirmation 'welcome'
  end
  
  factory :admin_user, class: "AdminUser" do
    name 'Admin User'
    sequence(:email){|n| "admin#{n}@email.com" }
    password 'welcome'
    password_confirmation 'welcome'
  end

  factory :user_with_gpg, class: 'User' do
    name 'my name'
    sequence(:email){|n| "usergpg#{n}@email.com" }
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
