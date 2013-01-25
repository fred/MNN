class CategoriesController < ApplicationController

  before_filter :check_params_encoding, only: [:show]

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
    @last_published = @last_modified
    # fresh_when(etag: @etag, last_modified: @last_published) unless (current_user or current_admin_user)
    no_cache_headers
  end

  def show
    @show_breadcrumb = true
    @category = Category.find(params[:id])
    @items = @category.
      items.
      localized.
      where(draft: false).
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
      @etag = Digest::MD5.hexdigest((Time.now.to_i / 900).to_s)
    else
      @last_published = @items.first.published_at
      @last_mofified = @last_published
      @etag = Digest::MD5.hexdigest(@items.map{|t| t.id}.to_s)
    end

    respond_to do |format|
      format.html {
        fresh_when(etag: @etag, last_modified: @last_published) unless (current_user or current_admin_user)
      }
      format.atom {
        headers['Etag'] = @etag
        public_headers(900)
        render partial: "/shared/items", layout: false 
      }
      format.rss {
        headers['Etag'] = @etag
        public_headers(900)
        render partial: "/shared/items", layout: false
      }
    end
  end

end
