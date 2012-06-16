# Images and File
ActiveAdmin.register Attachment do
  controller.authorize_resource
  config.sort_order = "id_desc"
  menu parent: "Items", priority: 2, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Attachment)
  }
  index as: :block do |attachment|
    div for: attachment, class: "grid_images" do
      h4 auto_link(attachment.attachable)
      div do
        if attachment.existing_attachment
          link_to(
            image_tag(attachment.existing_attachment.image.medium.url),
            admin_attachment_path(attachment),
            title: "Click on image to see details"
          )
        else
          link_to(
            image_tag(attachment.image.medium.url),
            admin_attachment_path(attachment),
            title: "Click on image to see details"
          )
        end
      end
      h4 auto_link(attachment.title)
      link_to(
        "Delete",
        admin_attachment_path(attachment),
        method: "delete",
        confirm: "Really delete this image?",
        title: "Click on image to see details"
      )
    end
  end
  show do
    render "show"
  end
  form partial: "form"
  controller do 
    def manage
      @attachments = Attachment.order('created_at DESC').page(params[:page])
      render :update do |page|
        page.replace_html :dynamic_images_list, partial: '/admin/attachments/show_attachment_list'
      end
    end
  end
end