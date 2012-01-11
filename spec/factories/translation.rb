FactoryGirl.define do
  factory :translation, :class => 'translation' do
    key 'hello'
    value 'Hello World'
    is_proc false
    locale 'en'
  end
  factory :translation2, :class => 'translation' do
    key 'hello'
    value 'Sawadee'
    is_proc false
    locale 'th'
  end
end
