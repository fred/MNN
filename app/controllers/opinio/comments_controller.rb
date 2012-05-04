class Opinio::CommentsController < ApplicationController
  include Opinio::Controllers::InternalHelpers
  include Opinio::Controllers::Replies if Opinio.accept_replies

  def index
    @comments = resource.comments.page(params[:page])
    headers['Cache-Control'] = 'private, no-cache'
  end

  def create
    @comment = resource.comments.build(params[:comment])
    if current_admin_user
      @comment.owner = current_admin_user
    elsif current_user
      @comment.owner = current_user
    else
      @comment.owner = nil
    end
    @comment.user_ip = request.remote_ip.to_s if @comment.respond_to?(:user_ip)
    @comment.user_agent = request.user_agent.to_s if @comment.respond_to?(:user_agent)
    @comment.approved = nil
    @comment.marked_spam = nil
    @comment.suspicious = nil
    @comment.approved_by = nil

    if @comment.save
      messages = { :notice => t('opinio.messages.comment_sent') }
    else
      messages = { :error => t('opinio.messages.comment_sending_error') }
    end
    headers['Cache-Control'] = 'private, no-cache'
    respond_to do |format|
      format.js
      format.html { redirect_to( resource, :flash => messages ) }
    end
  end

  def destroy
    @comment = Opinio.model_name.constantize.find(params[:id])

    if can_destroy_opinio?(@comment)
      @comment.destroy
      flash[:notice] = t('opinio.messages.comment_destroyed')
    else
      #flash[:error]  = I18n.translate('opinio.comment.not_permitted', default: "Not permitted")
      logger.warn "user #{send(Opinio.current_user_method)} tried to remove a comment from another user #{@comment.owner.id}"
      render text: "unauthorized", :status => 401 and return
    end

    respond_to do |format|
      format.js
      format.html { redirect_to( @comment.commentable ) }
    end
  end

  
end
