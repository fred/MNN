# Comments
ActiveAdmin.register Comment, :as => "UserComment" do
  config.comments = false
  menu :priority => 4, :label => "Comments"
end