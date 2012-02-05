FactoryGirl.define do
  factory :category, :class => "category" do
    title 'Category'
    description "Category"
  end
  factory :category1, :class => "category" do
    title 'Category 1'
    description "Category 1"
  end
  factory :category2, :class => "category" do
    title 'Category 2'
    description "Category 2"
  end
end
