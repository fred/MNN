class TagsController < ApplicationController

  def index
    @tags = Tag.order("type DESC, title ASC")
    @last_published = @last_mofified
    respond_to do |format|
      format.html {
        no_cache_headers
      }
    end
  end

  def show
    @show_breadcrumb = true
    @tag = Tag.find(params[:id])
    @items = @tag.items.localized.published.not_draft.order("published_at DESC").
      page(params[:page]).per(per_page)
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
    headers['Last-Modified'] = @last_published.httpdate

    respond_to do |format|
      format.html {
        no_cache_headers
      }
      format.atom {
        public_headers(900)
        render partial: "/shared/items", layout: false
      }
      format.rss {
        public_headers(900)
        render partial: "/shared/items", layout: false
      }
    end
  end

end
