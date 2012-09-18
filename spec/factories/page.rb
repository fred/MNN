FactoryGirl.define do
  factory :page, class: 'Page' do
    title 'Hello Page'
    body 'this is a long text'
    link_title "hello"
    priority 10
    active true
  end
  factory :page_two, class: 'Page' do
    title 'Hello Page 2'
    body 'this is a long text 2'
    link_title "hello 2"
    priority 20
    active true
  end
  factory :page_innactive, class: 'Page' do
    title 'Hello Page 2'
    body 'this is a long text 2'
    link_title "hello2"
    priority 12
    active false
  end
end
