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
  
end
