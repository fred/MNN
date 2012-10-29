class AttachmentsController < ApplicationController

  def create
    authorize! :create, Attachment
    # Take upload from params[:file] and store it somehow...
    # Optionally also accept params[:hint] and consume if needed
    @attachment = Attachment.new
    @attachment.image = params[:file] if params[:file]
    if @attachment.valid? && @attachment.save
      render json: {
        image: {
          url: @attachment.image.large.url
        }
      }, content_type: "text/html"
    end
  end

end
