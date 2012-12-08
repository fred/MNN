# Images and File
ActiveAdmin.register Attachment do

  filter :title
  filter :user_id
  filter :parent_id
  controller.authorize_resource
  config.sort_order = "id_desc"

  menu parent: "Items", label: 'Images', priority: 2, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Attachment)
  }

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
    # def update
    #   @attachment = Attachment.find(params[:id])
    #   if params[:attachment][:image].present? && params[:attachment][:image].is_a?(Array)
    #     params[:attachment][:image] = params[:attachment][:image].join
    #   end
    #   if @attachment.update_attributes(params[:attachment])
    #     flash[:success] = ("Image was updated")
    #     redirect_to admin_attachment_path(@attachment)
    #   else
    #     render action: 'edit'
    #   end
    # end

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
  end
end