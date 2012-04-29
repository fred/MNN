class TagsController < ApplicationController
  
  layout "items"
  
  def index
    @tags = Tag.order("type DESC, title ASC").all
    
    # Set the Last-Modified header so the client can cache the timestamp (used for later conditional requests)
    headers['Cache-Control'] = 'public, max-age=3600' # 1 hours cache
    headers['Last-Modified'] = Item.last_item.updated_at.httpdate
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
      format.xml { render @tags }
    end
  end

  def show
    @show_breadcrumb = true
    @tag = Tag.find(params[:id])
    # @items = @category.published_items.paginate(per_page: 20, page: params[:page])
    @items = @tag.
      items.
      where(:draft => false).
      includes(:attachments, :comments, :category, :language, :item_stat, :user, :tags).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      page(params[:page]).per(per_page)
    
    # RSS
    if @items.empty?
      @last_published = Time.now
    else
      @last_published = @items.first.published_at
    end
    @rss_title = "World Mathaba - News tagged #{@tag.title}"
    @rss_description = "World Mathaba - News tagged #{@tag.title}"
    @rss_category = @tag.title
    @rss_source = tags_path(@tag, :only_path => false, :protocol => 'https', :format => "html")
    headers['Last-Modified'] = @last_published.httpdate
    
    respond_to do |format|
      format.html {
        headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min cache
      }
      format.json { render json: @items }
      format.atom {
        headers['Cache-Control'] = 'public, max-age=3600' # 1 hour cache
        render :partial => "/shared/items", :layout => false
      }
      format.rss {
        headers['Cache-Control'] = 'public, max-age=3600' # 1 hour cache
        render :partial => "/shared/items", :layout => false
      }
      format.xml { render @items }
    end
  end

end
