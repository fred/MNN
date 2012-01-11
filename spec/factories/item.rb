FactoryGirl.define do
  
  factory :item, :class => 'Item' do
    title 'Some News'
    abstract "Some Abstract"
    body "Some body"
    association :language, :factory => :language
    association :category, :factory => :category
    # association :user, :factory => :user
    featured false
    draft false
    published_at Time.now-600
  end
  
  factory :item2, :class => 'Item' do
    title 'Some News'
    abstract "Some Abstract"
    body "Some body"
    association :language, :factory => :language2
    association :category, :factory => :category2
    # association :user, :factory => :user2
    featured false
    draft false
    published_at Time.now-600
  end
  
  factory :item_highlight, :class => 'Item' do
    title 'Some News Highlight'
    abstract "Some Abstract 2"
    body "a very long body"
    association :language, :factory => :language
    association :category, :factory => :category1
    association :user, :factory => :user
    featured true
    draft false
    published_at Time.now-600
  end
  
  factory :item_unpublished, :class => 'Item' do
    title 'Some News in future'
    abstract "Some Abstract 3"
    body "a very long body"
    association :language, :factory => :language
    association :category, :factory => :category2
    association :user, :factory => :admin
    featured false
    draft false
    published_at Time.now+600
  end
  
  factory :item_draft, :class => 'Item' do
    title 'Some News Draft'
    abstract "Some Abstract draft"
    body "a very long body"
    association :language, :factory => :language
    association :category, :factory => :category2
    association :user, :factory => :admin
    draft true
    published_at Time.now-600
  end

end
