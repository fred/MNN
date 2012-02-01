# Comments
ActiveAdmin.register Comment, :as => "UserComment" do
  config.comments = false
  menu :priority => 8, :label => "Comments"
end