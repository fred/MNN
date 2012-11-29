class ItemsController < ApplicationController
  
  def feed
    headers_with_timeout(Settings.cache_time)
  end
  
  def index
    @show_breadcrumb = true
    if params[:language_id]
      @language = Language.find(params[:language_id])
      @rss_title = "World Mathaba - News in #{@language.description} Language"
      @rss_description = "World Mathaba - News in #{@language.description} Language"
      @rss_language = @language.locale
      @rss_source = items_path(language_id: params[:language_id], only_path: false)
      @meta_keywords = "#{@language.description}, WorldMathaba"
      @items = Item.published.not_draft.
        includes(:attachments).
        where(language_id: @language.id).
        order("published_at DESC").
        page(params[:page]).per(per_page)
    else
      @rss_title = "World Mathaba - Latest News"
      @rss_description = "World Mathaba - Latest News"
      @rss_source = items_path(only_path: false, protocol: 'https')
      @rss_language = "en"
      @items = Item.published.localized.not_draft.
        includes(:attachments).
        order("published_at DESC").
        page(params[:page]).per(per_page)
    end
    @meta_description = @rss_description
    @meta_title = @rss_title
    if @items.empty?
      @last_published = Time.now
      @etag = Digest::MD5.hexdigest((Time.now.to_i / 600).to_s)
    else
      @etag = Digest::MD5.hexdigest(@items.map{|t| t.id}.to_s)
      @last_published = @items.first.published_at
    end

    respond_to do |format|
      format.html {
        fresh_when(etag: @etag, last_modified: @last_published) unless (current_user or current_admin_user)
      }
      format.json { render json: @items }
      format.atom {
        public_headers(900)
        headers['Etag'] = @etag
        render partial: "/shared/items", layout: false
      }
      format.rss {
        public_headers(900)
        headers['Etag'] = @etag
        render partial: "/shared/items", layout: false
      }
    end
  end

  def show
    @item = Item.includes([:attachments, :user, :category, :language]).find(params[:id])
    @comments = @item.approved_comments.page(params[:page]).per(30)
    @show_breadcrumb = true
    if @item && view_context.is_human? && (@item_stat = @item.item_stat)
      if session[:view_items] && !session[:view_items].include?(@item.id)
        @item_stat.views_counter += 1
        @item_stat.save
        session[:view_items] << @item.id
      end
    end
    @meta_title = @item.title + " - World Mathaba"
    @meta_description = "News #{@item.category_title} - #{@item.abstract}"
    @meta_keywords = @item.meta_keywords
    @meta_author = @item.user.title if @item.user

    fresh_when(etag: @item, last_modified: @item.updated_at) unless (current_user or current_admin_user)
  end

  def new
    redirect_to root_path
  end
  def edit
    redirect_to root_path
  end
  def destroy
    redirect_to root_path
  end

  def search
    faceted_results = ""
    @show_breadcrumb = false
    if params[:category_id]
      category = Category.where(id: params[:category_id]).first
    end
    if params[:language_id]
      language = Language.where(id: params[:language_id]).first
    end
    
    if params[:q] && !params[:q].to_s.empty?
      store_query # Save query to DB
      term = params[:q].downcase
      @search = Item.solr_search(include: [:attachments, :comments, :category, :language, :item_stat, :user, :tags]) do
        fulltext term do
          phrase_fields author_name: 4.0
          phrase_fields title: 2.4
          phrase_fields abstract: 1.6
          phrase_fields tags: 1.6
          phrase_fields body: 1.2
        end
        if category
          with(:category_id, category.id)
          faceted_results << " under #{category.title} "
        end
        if language
          with(:language_id, language.id)
          faceted_results << " in #{language.description} "
        else
          with(:language_id, Item.default_language.id) if Item.default_language
        end
        with(:draft, false)
        facet(:category_id)
        facet(:language_id)
        facet(:user_id)
        order_by(:published_at,:desc)
        paginate page: page, per_page: per_page
      end
      if page && page > 1
        faceted_results << " - page #{page}"
      end
      @items = @search.results
      @title = "WorldMathaba - Found #{@search.total} results for '#{params[:q]}' #{faceted_results}"
      @meta_title = @title
      @meta_description = @title
      @rss_description = @title
      @rss_title = "WorldMathaba Search - #{params[:q]}"
      @last_published = @items.first.published_at unless @items.empty?
      @faceted_results = faceted_results
    else
      @items = []
      @title = "Please type something to search for"
    end
    private_headers_with_timeout
    respond_to do |format|
      format.html
      format.js
      format.atom {
        render partial: "/shared/items", layout: false
      }
      format.rss {
        render partial: "/shared/items", layout: false
      }
    end
  end
  
  comment_destroy_conditions do |comment|
    current_admin_user && (can? :destroy, Comment)
  end


  protected
  def store_query
    if view_context.is_human? && !current_admin_user
      raw = {}
      raw[:ip] = request.remote_ip if request.remote_ip
      raw[:referrer] = request.referrer if request.referrer
      raw[:user_agent] = request.user_agent if request.user_agent
      q = {}
      q[:query]   = params[:q]
      q[:user_id] = current_user.id if current_user
      q[:locale]  = I18n.locale
      q[:raw_data]= raw
      if Rails.env.production?
        Query.delay.store(q)
      else
        Query.store(q)
      end
    end
  end
end
