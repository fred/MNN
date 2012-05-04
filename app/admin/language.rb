ActiveAdmin.register Language do
  controller.authorize_resource

  menu parent: "Settings", priority: 90, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Language)
  }

  config.comments = false
end
