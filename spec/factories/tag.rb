FactoryGirl.define do
  factory :tag, class: 'Tag' do
    title 'Just a Tag'
  end
  factory :region_tag, class: 'RegionTag' do
    title 'Region Tag'
  end
  factory :country_tag, class: 'CountryTag' do
    title 'Country Tag'
  end
  factory :general_tag, class: 'GeneralTag' do
    title 'General Tag 1'
  end
end
