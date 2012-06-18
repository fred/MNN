FactoryGirl.define do
  factory :comment, class: 'Comment' do
    association :commentable, factory: :item
    association :owner, factory: :user
    body 'This is a test message'
    approved true
    user_ip "127.0.0.1"
  end
end
