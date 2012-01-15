class ItemsController < ApplicationController
  
  layout "items"
  
  # GET /items
  # GET /items.json
  def index
    @show_breadcrumb = true
    if params[:language_id]
      @language = Language.find(params[:language_id])
      @items = Item.published.not_draft.
        where(:language_id => @language.id).
        order("published_at DESC").
        page(params[:page], :per_page => 20)
    else
      @items = Item.published.not_draft.
        order("published_at DESC").
        page(params[:page], :per_page => 20)
    end
    
    headers['Cache-Control'] = 'public, max-age=300' # 5 min cache
    headers['Last-Modified'] = Item.last_item.updated_at.httpdate if Item.last_item
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @show_breadcrumb = true
    if @item
      # Set the Last-Modified header so the client can cache the timestamp (used for later conditional requests)
      headers['Cache-Control'] = 'public, max-age=300' # 5 min cache
      headers['Last-Modified'] = @item.updated_at.httpdate
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
        keywords term
        if category
          with(:category_id, category.id)
        end
        if language
          with(:language_id, language.id)
        end
        with(:draft, false)
        facet(:category_id)
        facet(:language_id)
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

    # client side cache for 10 minutes
    headers['Cache-Control'] = 'public, max-age=600'
    respond_to do |format|
      format.html
      format.js
    end
  end
  
end
