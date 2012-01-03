# Categories
ActiveAdmin.register Category do
  config.comments = false
  menu :priority => 10
  index do
    column :id
    column :title
    column :description
    column :priority
    column "Active" do |category|
      bol_to_word(category.active)
    end
    column "Updated" do |category|
      category.updated_at.to_s(:short)
    end
  end
end
