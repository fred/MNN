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
    @categories = @site_categories
    private_headers
    respond_to do |format|
      format.html
    end
  end

  def show
    @show_breadcrumb = true
    @category = Category.find(params[:id])
    @items = @category.
      items.
      localized.
      where(draft: false).
      includes(:attachments).
      where("published_at is not NULL").
      where("published_at < ?", Time.now).
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
    @meta_keywords = "#{@category.title} news"

    if @items.empty?
      @etag = Digest::MD5.hexdigest((Time.now.to_i / 600).to_s)
    else
      @last_published = @items.first.published_at
      @last_mofified = @last_published
      @etag = Digest::MD5.hexdigest(@items.map{|t| t.id}.to_s)
    end
    
    respond_to do |format|
      format.html {
        headers_with_timeout(600, 'public')
      }
      format.atom {
        headers['Etag'] = @etag
        headers['Cache-Control'] = 'public, max-age=1200'
        headers['Last-Modified'] = @last_published.httpdate if @last_published
        render partial: "/shared/items", layout: false 
      }
      format.rss {
        headers['Etag'] = @etag
        headers['Cache-Control'] = 'public, max-age=1200'
        headers['Last-Modified'] = @last_published.httpdate if @last_published
        render partial: "/shared/items", layout: false
      }
      format.json { render json: @items }
      format.xml { render @items }
    end
  end

end
