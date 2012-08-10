class TagsController < ApplicationController
  
  def index
    @tags = Tag.order("type DESC, title ASC").all
    headers['Last-Modified'] = Item.last_item.updated_at.httpdate
    
    private_headers
    respond_to do |format|
      format.html {
        headers_with_timeout(180)
      }
    end
  end

  def show
    @show_breadcrumb = true
    @tag = Tag.find(params[:id])
    @items = @tag.
      items.
      localized.
      where(draft: false).
      includes(:attachments, :category, :language, :item_stat, :user, :tags).
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
    @rss_title = "World Mathaba - #{@tag.title} News"
    @meta_title = @rss_title
    @rss_description = "World Mathaba - Latest News about #{@tag.title}"
    @meta_description = @rss_description
    @meta_keywords = "#{@tag.title} news"
    @rss_category = @tag.title
    @rss_source = tags_path(@tag, only_path: false, protocol: 'https', format: "html")
    @last_mofified = @last_published
    headers['Last-Modified'] = @last_published.httpdate
    
    private_headers
    respond_to do |format|
      format.html {
        headers_with_timeout(180)
      }
      format.atom {
        headers_with_timeout(900)
        render partial: "/shared/items", layout: false
      }
      format.rss {
        headers_with_timeout(900)
        render partial: "/shared/items", layout: false
      }
    end
  end

end
