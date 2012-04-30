FactoryGirl.define do
  factory :attachment, :class => 'attachment' do
    title 'Some attachment title. It should not show more than 100 characters on show page. It should be truncated to before this.'
    image { 
      fixture_file_upload "#{Rails.root}/app/assets/images/rails.png", 'image/png'
    }
    to_create do |instance|
      instance.save!(:validate => false)
    end
  end
end
