FactoryGirl.define do
  factory :attachment, :class => 'attachment' do
    title 'Some attachment'
    image { 
      fixture_file_upload "#{Rails.root}/app/assets/images/rails.png", 'image/png'
    }
    to_create do |instance|
      instance.save!(:validate => false)
    end
  end
end
