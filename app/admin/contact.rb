# Comments
ActiveAdmin.register Contact do
  controller.authorize_resource
  config.comments = false
  menu priority: 58, parent: "More", label: "AddressBook", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Contact)
  }
end
