# Comments
ActiveAdmin.register Contact do
  controller.authorize_resource
  config.comments = false
  menu priority: 58, parent: "More", label: "AddressBook", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Contact)
  }

  menu parent: "Items", label: 'Item Stats', priority: 3, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, ItemStat)
  }
end