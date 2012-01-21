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
      includes(:language, :attachments, :tags, :item_stat, :user).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      page(params[:page]).per(20)
    
    # RSS
    @last_published = @items.first.published_at
    @rss_title = "Latest News tagged in #{@tag.title}"
    @rss_description = "MNN - Latest News tagged in #{@tag.title}"
    @rss_category = @tag.title
    @rss_source = tags_path(@tag, :only_path => false, :protocol => 'http', :format => "html")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
      format.atom { render :partial => "/shared/items", :layout => false }
      format.rss  { render :partial => "/shared/items", :layout => false }
      format.xml { render @items }
    end
  end

end
