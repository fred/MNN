FactoryGirl.define do
  factory :score, :class => "Score" do
    points 1
    association :user, :factory => :user
  end
end
