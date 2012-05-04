FactoryGirl.define do
  
  factory :item_stat, class: 'ItemStat' do 
    views_counter 2
    association :item, factory: :item
  end

end