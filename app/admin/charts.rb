ActiveAdmin.register_page "Charts" do
  menu priority: 1, label: "Charts"

  action_item do
    link_to "Website", "/"
  end
  action_item do
    link_to "Admin", "/admin"
  end

  content do
    render "charts"
  end
end
