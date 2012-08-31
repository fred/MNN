# Images and File
ActiveAdmin.register Attachment do

  filter :title
  controller.authorize_resource
  config.sort_order = "id_desc"

  menu parent: "Items", label: 'Images', priority: 2, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Attachment)
  }

  index as: :block do |attachment|
    div for: attachment, class: "grid_images" do
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
      para(auto_link(attachment.attachable))
      para(attachment.title)
      para(
        link_to(
          "Edit",
          edit_admin_attachment_path(attachment),
          title: "Edit Image"
        ) + " - " +
        link_to(
          "Delete",
          admin_attachment_path(attachment),
          method: "delete",
          confirm: "Really delete this image?",
          title: "Click on image to see details"
        )
      )
    end
  end

  show do
    render "show"
  end

  form partial: "form"

  controller do
    def create
      if params[:attachment][:image].present? && params[:attachment][:image].is_a?(Array)
        @count = 0
        params[:attachment][:image].each do |uploaded_image|
          Rails.logger.debug("Uploading Image...")
          image = Attachment.new(params[:attachment])
          image.image = uploaded_image
          if image.valid? && image.save
            @count += 1
          end
        end
        flash[:notice] = "Successfully Uploaded #{@count} images"
      else
        @image = Attachment.new(params[:attachment])
        unless @image.save
          render action: 'new'
        end
        @image.save if @image.valid?
        flash[:notice] = "Successfully Uploaded Image"
      end
      redirect_to admin_attachments_path
    end
  end

end