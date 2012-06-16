FactoryGirl.define do
  factory :document, class: 'document' do
    title 'Some document title'
    data { 
      fixture_file_upload "#{Rails.root}/public/robots.txt"
    }
    to_create do |instance|
      instance.save!(validate: false)
    end
  end
end
