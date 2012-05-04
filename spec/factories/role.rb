FactoryGirl.define do
  factory :role, class: 'Role' do
    title 'role'
  end
  factory :role_admin, class: 'Role' do
    title 'admin'
  end
  factory :role_basic, class: 'Role' do
    title 'basic'
  end
  factory :role_security, class: 'Role' do
    title 'security'
  end
  factory :role_author, class: 'Role' do
    title 'author'
  end
  factory :role_editor, class: 'Role' do
    title 'editor'
  end
  factory :role_reader, class: 'Role' do
    title 'reader'
  end
end
