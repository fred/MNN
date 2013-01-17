class ItemsController < ApplicationController
  before_filter :check_params_encoding, only: [:show]
  after_filter :store_page_view, only: [:show]

  def vote
    return false unless current_user
    @item = Item.find(params[:item_id])

    if @item.user_id == current_user.id
      @own_article = true
    elsif current_user.voted_on?(@item)
      @already_voted = true
      if params[:vote] == "delete"
        @vote_deleted = true
        current_user.unvote_for(@item)
      end
    else
      @already_voted = false
      if params[:vote] == "up"
        @voted = true
        current_user.vote_for @item
      elsif params[:vote] == "down"
        @voted = true
        current_user.vote_against @item
      end
    end
    no_cache_headers
  end
  
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
        no_cache_headers
      }
      format.json { render json: @items }
      format.atom {
        public_headers(1200)
        headers['Etag'] = @etag
        render partial: "/shared/items", layout: false
      }
      format.rss {
        public_headers(1200)
        headers['Etag'] = @etag
        render partial: "/shared/items", layout: false
      }
    end
  end

  def show
    @item = Item.includes([:attachments, :user, :category, :language]).find_from_slug(params[:id].to_s).first
    if params[:id].to_s.match("^[a-zA-Z]") && @item && @item.slug.match("^[0-9]+-")
      redirect_to(item_path(@item), status: 301)
    end
    @comments = @item.approved_comments.page(params[:page]).per(30)
    @show_breadcrumb = true
    @meta_title = @item.title + " - World Mathaba"
    @meta_description = "News #{@item.category_title} - #{@item.abstract}"
    @meta_keywords = @item.meta_keywords
    @meta_author = @item.user.title if @item.user
    increment_counter
    no_cache_headers
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
      term = params[:q].downcase
      @search = Item.solr_search(include: [:attachments, :comments, :category, :language, :item_stat, :user, :tags]) do
        fulltext term
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
      store_query
    else
      @items = []
      @title = "Please type something to search for"
    end

    respond_to do |format|
      format.html {
        no_cache_headers
      }
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

  def increment_counter
    if @item && view_context.is_human? && (@item_stat = @item.item_stat)
      if session[:view_items] && !session[:view_items].include?(@item.id) && !ip_has_visited?(1)
        @item_stat.views_counter += 1
        @item_stat.save
        session[:view_items] << @item.id
      end
    end
  end

  def store_query
    safe = params[:q] && params[:q].scan(/select|where|\(|\)/).uniq.size <= 1
    if safe && (current_user or current_admin_user or view_context.is_human?)
      data = {}
      data["ip"] = request.remote_ip if request.remote_ip
      data["referrer"] = request.referrer if request.referrer
      data["user_agent"] = request.user_agent if request.user_agent
      q = {}
      q[:keyword] = params[:q] if params[:q].present?
      q[:item_id] = @item.id if @item
      q[:user_id] = current_user.id if current_user
      q[:locale]  = I18n.locale
      q[:data]= data
      if Rails.env.production?
        SearchQuery.delay.store(q)
      else
        SearchQuery.store(q)
      end
    end
  end

  def store_page_view
    if (current_user or current_admin_user or view_context.is_human?) && !ip_has_visited?(10)
      data = {}
      data["ip"] = request.remote_ip if request.remote_ip
      data["referrer"] = request.referrer if request.referrer
      data["user_agent"] = request.user_agent if request.user_agent
      q = {}
      q[:item_id] = @item.id if @item
      q[:user_id] = current_user.id if current_user
      q[:locale]  = I18n.locale
      q[:data]= data
      if Rails.env.production?
        PageView.delay.store(q)
      else
        PageView.store(q)
      end
    end
  end

  def ip_has_visited?(times = 2)
    count = PageView.where("data -> 'ip' = :value", value: request.remote_ip).
      where(item_id: @item.id).
      where("created_at > ?", Time.now-2.day).
      count
    if count > times
      true
    else
      false
    end
  end

end
