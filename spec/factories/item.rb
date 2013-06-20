FactoryGirl.define do
  
  factory :item, class: 'Item' do 
    sequence(:title){|n| "Some News #{n}" }
    abstract "Some Abstract"
    body "Some body"
    association :language, factory: :language
    association :category, factory: :category
    featured false
    draft false
    published_at Time.now-600
    source_url "http://hello.world"
  end
  
  factory :item2, class: 'Item' do
    sequence(:title){|n| "Some News #{n}" }
    abstract "Some Abstract"
    body "Some body"
    association :language, factory: :language2
    association :category, factory: :category2
    featured false
    draft false
    published_at Time.now-600
  end
  
  factory :item_highlight, class: 'Item' do
    sequence(:title){|n| "Some News Highlight #{n}" }
    abstract "Some Abstract 2"
    body "a very long body"
    association :language, factory: :language
    association :category, factory: :category1
    association :user, factory: :user
    featured true
    draft false
    published_at Time.now-600
  end
  
  factory :item_unpublished, class: 'Item' do
    sequence(:title){|n| "Some News in the Future #{n}" }
    abstract "Some Abstract 3"
    body "a very long body"
    association :language, factory: :language
    association :category, factory: :category2
    association :user, factory: :admin
    featured false
    draft false
    published_at Time.now+600
  end
  
  factory :item_draft, class: 'Item' do
    sequence(:title){|n| "Some Draft article #{n}" }
    abstract "Some Abstract draft"
    body "a very long body"
    association :language, factory: :language
    association :category, factory: :category2
    draft true
    published_at Time.now-600
  end

end
