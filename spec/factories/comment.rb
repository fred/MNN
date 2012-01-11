FactoryGirl.define do
  factory :message, :class => 'Comment' do
    ownner_id 1
    commentable_id 1
    commentable_type "User"
    body 'This is a test message'
    approved true
    # humanizer_bypass true
  end
end
