ActiveAdmin.register Language do
  controller.authorize_resource
  
  menu :parent => "Settings", :priority => 90
  config.comments = false
end
