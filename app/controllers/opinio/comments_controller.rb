class Opinio::CommentsController < ApplicationController
  include Opinio::Controllers::InternalHelpers
  include Opinio::Controllers::Replies if Opinio.accept_replies

  def index
    if params[:item_id]
      @item = Item.includes([:comments,:item_stat]).find(params[:item_id])
      @comments = @item.comments.page(params[:page]).per(10)
      @rss_title = "Comments for: #{@item.title}"
      @rss_description = "RSS comments for '#{@item.title}'"
      @rss_source = item_comments_path(@item, only_path: false, protocol: 'https')
      @rss_language = "en"
      @last_published = @item.last_commented_at
    elsif params[:mine]
      @comments = current_user.comments.order('id DESC').page(params[:page]).per(10)
    else
      @comments = Comment.order('id DESC').page(params[:page]).per(10)
    end

    private_headers
    respond_to do |format|
      format.js
      format.html
      format.xml
      format.rss
      format.atom
    end
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
      messages = { notice: t('opinio.messages.comment_sent') }
    else
      messages = { error: t('opinio.messages.comment_sending_error') }
    end
    private_headers
    respond_to do |format|
      format.js
      format.html { redirect_to( resource, flash: messages ) }
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
      render text: "unauthorized", status: 401 and return
    end

    respond_to do |format|
      format.js
      format.html { redirect_to( @comment.commentable ) }
    end
  end

  def show
    @comment = Opinio.model_name.constantize.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    if current_user
      owner_id = current_user.id
    elsif current_admin_user
      owner_id = current_admin_user.id
    end
    begin
      @comment = Opinio.model_name.constantize.where(id: params[:id], owner_id: owner_id).first
    rescue
      redirect_to root_path
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    if current_user
      owner_id = current_user.id
    elsif current_admin_user
      owner_id = current_admin_user.id
    end
    @comment = Opinio.model_name.constantize.where(id: params[:id], owner_id: owner_id).first
    if params[:comment] && @comment.update_attribute(:body, params[:comment][:body])
      flash[:success] = "Comment Updated"
    end
    respond_to do |format|
      format.js
      format.html {
        redirect_to @comment.commentable
      }
    end
  end
  
end
