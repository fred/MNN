ActiveAdmin.register Language do
  controller.authorize_resource

  menu parent: "More", priority: 56, label: "Languages", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Language)
  }

  config.comments = false
end
