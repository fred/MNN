class CategoriesController < ApplicationController
    
  def index
    @sticky_item = Item.top_sticky
    if @sticky_item
      @highlights = [@sticky_item]
      @latest_items = Item.highlights(3)
    else
      @top_items = Item.highlights(4)
      @highlights = [@top_items.first]
      @latest_items = @top_items[1..3]
    end
    @categories = Category.order("priority ASC, title DESC").all
    # headers['Cache-Control'] = 'public, max-age=300' unless (current_admin_user or current_user) # 10 min cache
    # headers['Last-Modified'] = Item.last_item.updated_at.httpdate
  end

  def show
    @show_breadcrumb = true
    @category = Category.find(params[:id])
    headers['Cache-Control'] = 'public, max-age=300' unless (current_admin_user or current_user) # 5 min cache
    headers['Last-Modified'] = @category.items.last_item.updated_at.httpdate
    @items = @category.
      items.
      localized.
      where(draft: false).
      includes(:attachments, :category, :language, :item_stat, :user, :tags).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      page(params[:page]).per(per_page)

    # RSS configuration
    @rss_title = "World Mathaba - #{@category.title} News"
    @meta_title = @rss_title
    @rss_description = "#{@category.description} News"
    @meta_description = @rss_description
    @rss_source = url_for(@category)
    @rss_category = @category.title
    @rss_language = "en"
    @last_published = @items.first.published_at
    @last_mofified = @last_published
    @meta_keywords = "#{@category.title} news"

    if @items.empty?
      @etag = Digest::MD5.hexdigest((Time.now.to_i / 600).to_s)
    else
      @etag = Digest::MD5.hexdigest(@items.map{|t| t.id}.to_s)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.atom {
        headers['Etag'] = @etag
        headers['Cache-Control'] = 'public, max-age=900'
        headers['Last-Modified'] = @last_published.httpdate
        render partial: "/shared/items", layout: false 
      }
      format.rss {
        headers['Etag'] = @etag
        headers['Cache-Control'] = 'public, max-age=900'
        headers['Last-Modified'] = @last_published.httpdate
        render partial: "/shared/items", layout: false
      }
      format.json { render json: @items }
      format.xml { render @items }
    end
  end

end
