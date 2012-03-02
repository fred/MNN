class CategoriesController < ApplicationController
  
  layout "items"
    
  def index
    @top_items = Item.highlights(4)
    @highlights = [@top_items.first]
    @latest_items = @top_items[1..3]
    @categories = Category.order("priority ASC, title DESC").all
    headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min cache
    headers['Last-Modified'] = Item.last_item.updated_at.httpdate
  end

  def show
    @show_breadcrumb = true
    @category = Category.find(params[:id])
    headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min cache
    headers['Last-Modified'] = @category.items.last_item.updated_at.httpdate
    @items = @category.
      items.
      where(:draft => false).
      includes(:language, :attachments, :tags, :item_stat, :user).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      page(params[:page]).per(per_page)
    
    # RSS configuration
    @rss_title = "Latest News for #{@category.title}"
    @rss_description = "MNN - Latest News for #{@category.title}"
    @rss_source = url_for(@category)
    @rss_category = @category.title
    @rss_language = "en"
    
    @last_published = @items.first.published_at
    
    respond_to do |format|
      format.html # index.html.erb
      format.atom {
        headers['Cache-Control'] = 'public, max-age=3600' # 1 hour cache
        headers['Last-Modified'] = @last_published.httpdate
        render :partial => "/shared/items", :layout => false 
      }
      format.rss  {
        headers['Cache-Control'] = 'public, max-age=3600' # 1 hour cache
        headers['Last-Modified'] = @last_published.httpdate
        render :partial => "/shared/items", :layout => false
      }
      format.json { render json: @items }
      format.xml { render @items }
    end
  end

end
