# TAGS
ActiveAdmin.register Tag do
  config.comments = false
  menu :parent => "Tags", :priority => 15
  form :partial => "form"
end
ActiveAdmin.register GeneralTag do
  config.comments = false
  menu :parent => "Tags", :priority => 15
  form :partial => "form"
end
ActiveAdmin.register RegionTag do
  config.comments = false
  menu :parent => "Tags", :priority => 17
  form :partial => "form"
end
ActiveAdmin.register CountryTag do
  config.comments = false
  menu :parent => "Tags", :priority => 19
  form :partial => "form"
end
