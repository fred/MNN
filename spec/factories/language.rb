FactoryGirl.define do
  
  factory :language, :class => 'Language' do
    description 'English'
    locale 'en'
  end
  
  factory :language2, :class => 'Language' do
    description 'Spanish'
    locale 'es'
  end
  
end
