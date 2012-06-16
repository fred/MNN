# Images and File
ActiveAdmin.register Document do
  controller.authorize_resource
  config.sort_order = "id_desc"
  menu parent: "Items", priority: 20, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Document)
  }
end