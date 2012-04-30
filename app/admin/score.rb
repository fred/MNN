# Scores
ActiveAdmin.register Score do
  controller.authorize_resource
  
  config.comments = false
  menu :parent => "Members", :priority => 35, :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Score)
  }
end