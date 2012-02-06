# Images and File
ActiveAdmin.register Attachment do
  controller.authorize_resource
  config.sort_order = "id_desc"
  menu :parent => "Items", :priority => 2
  default_per_page = 80
  index :as => :block do |attachment|
    div :for => attachment, :class => "grid_images" do
      h4 auto_link(attachment.attachable)
      div do
        link_to(
          image_tag(attachment.image.medium.url),
          admin_attachment_path(attachment),
          :title => "Click on image to see details"
        )
      end
      h4 auto_link(attachment.title)
      link_to(
        "Delete",
        admin_attachment_path(attachment),
        :method => "delete",
        :confirm => "Really delete this image?",
        :title => "Click on image to see details"
      )
    end
  end
  show do
    render "show"
  end
  form :partial => "form"
end