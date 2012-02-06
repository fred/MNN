class ItemsController < ApplicationController
  
  layout "items"
  
  def feed
    headers['Cache-Control'] = 'public, max-age=3600' unless (current_admin_user or current_user) # 60 minutes cache
  end
  
  # GET /items
  # GET /items.json
  def index
    @show_breadcrumb = true
    if params[:language_id]
      @language = Language.find(params[:language_id])
      @rss_title = "Latest News in #{@language.description}"
      @rss_description = "MNN - Latest News in #{@language.description}"
      @rss_language = @language.locale
      @rss_source = items_path(:language_id => params[:language_id], :only_path => false, :protocol => 'https')
      @items = Item.published.
        not_draft.
        includes(:language, :attachments, :tags, :item_stat, :user).
        where(:language_id => @language.id).
        order("published_at DESC").
        page(params[:page], :per_page => 20)
    else
      @rss_title = "Latest News"
      @rss_description = "MNN - Latest News"
      @rss_source = items_path(:only_path => false, :protocol => 'https')
      @rss_language = "en"
      @items = Item.published.
        not_draft.
        includes(:language, :attachments, :tags, :item_stat, :user).
        order("published_at DESC").
        page(params[:page], :per_page => 20)
    end
    if @items.empty?
      @last_published = Time.now
    else
      @last_published = @items.first.published_at
    end
    
    # headers['Cache-Control'] = 'public, max-age=300' # 5 minutes cache
    # headers['Last-Modified'] = @last_published.httpdate
    
    respond_to do |format|
      format.html {
        headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min cache
        headers['Last-Modified'] = @last_published.httpdate
      }
      format.json {
        headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min cache
        headers['Last-Modified'] = @last_published.httpdate
        render json: @items 
      }
      format.atom {
        headers['Cache-Control'] = 'public, max-age=3600' unless (current_admin_user or current_user) # 1 hour cache
        headers['Last-Modified'] = @last_published.httpdate
        render :partial => "/shared/items", :layout => false }
      format.rss {
        headers['Cache-Control'] = 'public, max-age=3600' unless (current_admin_user or current_user) # 1 hour cache
        headers['Last-Modified'] = @last_published.httpdate
        render :partial => "/shared/items", :layout => false 
      }
      format.xml {
        headers['Cache-Control'] = 'public, max-age=600' unless (current_admin_user or current_user) # 10 min cache
        headers['Last-Modified'] = @last_published.httpdate
        render @items
      }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @show_breadcrumb = true
    if @item && is_human?
      if @item.item_stat
        @item_stat = @item.item_stat
        if session[:view_items] && !session[:view_items].include?(@item.id)
          @item_stat.update_attributes(:views_counter => @item_stat.views_counter+1)
          session[:view_items] << @item.id
        end
      else
        @item_stat = ItemStat.create(:item_id => @item.id, :views_counter => 1)
      end
    end
    @related = @item.solr_similar
    
    headers['Cache-Control'] = 'private, max-age=900, must-revalidate' unless (current_admin_user or current_user) 
    # 15 minutes cache, because of comments.
    headers['Last-Modified'] = @item.updated_at.httpdate
    respond_to do |format|
      format.html
      format.json { render json: @item }
    end
  end

  # # GET /items/new
  # # GET /items/new.json
  # def new
  #   @item = Item.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render json: @item }
  #   end
  # end
  # 
  # # GET /items/1/edit
  # def edit
  #   @item = Item.find(params[:id])
  # end
  # 
  # # POST /items
  # # POST /items.json
  # def create
  #   @item = Item.new(params[:item])
  # 
  #   respond_to do |format|
  #     if @item.save
  #       format.html { redirect_to @item, notice: 'Item was successfully created.' }
  #       format.json { render json: @item, status: :created, location: @item }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /items/1
  # # PUT /items/1.json
  # def update
  #   @item = Item.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @item.update_attributes(params[:item])
  #       format.html { redirect_to @item, notice: 'Item was successfully updated.' }
  #       format.json { head :ok }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /items/1
  # # DELETE /items/1.json
  # def destroy
  #   @item = Item.find(params[:id])
  #   @item.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to items_url }
  #     format.json { head :ok }
  #   end
  # end
  
  
  
  
  
  def search
    @show_breadcrumb = false
    if params[:per_page]
      @per_page = params[:per_page]
    else
      @per_page = 20
    end
    if params[:category_id]
      category = Category.where(:id => params[:category_id]).first
    end
    if params[:language_id]
      language = Language.where(:id => params[:language_id]).first
    end
    if params[:q] && !params[:q].to_s.empty?
      term = params[:q].downcase
      @search = Item.solr_search do
        fulltext term do
          phrase_fields :title => 1.8
          phrase_fields :abstract => 1.6
          phrase_fields :tags => 1.5
          phrase_fields :body => 1.4
          phrase_slop   1
        end
        if category
          with(:category_id, category.id)
        end
        if language
          with(:language_id, language.id)
        end
        with(:draft, false)
        facet(:category_id)
        facet(:language_id)
        facet(:user_id)
        order_by(:published_at,:desc)
        paginate :page => params[:page], :per_page => 20
      end

      # showing Sponsored Listings
      @items = @search.results
      
      @title = "Found #{@search.total} results with '#{params[:q]}' "
    else
      # If no search term has been given, empty search
      @items = Item.published.not_draft.
        order("published_at DESC").
        page(params[:page], :per_page => 20)
    end

    # client side cache for 15 minutes
    headers['Cache-Control'] = 'public, max-age=900' unless (current_admin_user or current_user)
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
