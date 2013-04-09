ActiveAdmin.register Attachment do
  filter :title
  filter :user_id
  filter :parent_id
  config.sort_order = "id_desc"
  menu parent: "Items", label: 'Images', priority: 2

  index title: "Images", as: :block do |attachment|
    div for: attachment, class: "grid_images" do
      render 'attachment', attachment: attachment
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

  controller do
    def scoped_collection
      Attachment.includes(:attachable)
    end
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_authorization_denied_path, alert: exception.message
    end
  end
end
