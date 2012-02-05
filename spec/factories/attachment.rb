FactoryGirl.define do
  
  factory :attachment, :class => 'attachment' do
    title 'Some attachment'
    # image fixture_file_upload("#{Rails.root}/app/assets/images/rails.png", 'image/png')
  end
  
  factory :attachment_two, :class => 'attachment' do
    title 'Some attachment two'
  end

end
