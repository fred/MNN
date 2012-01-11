FactoryGirl.define do
  factory :role, :class => 'Role' do
    title 'Role'
  end
  factory :role_admin, :class => 'Role' do
    title 'Admin Role'
  end
end
