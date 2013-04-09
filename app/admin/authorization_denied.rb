ActiveAdmin.register_page "Authorization Denied" do
  menu false

  action_item do
    link_to "Website", "/"
  end
  action_item do
    link_to "Admin", "/admin"
  end

  content do
    h4 "Sorry, but you don't have enough privileges to access that page."
    para "If you believe this is an error, please contact admin@worldmathaba.net"
  end
end
