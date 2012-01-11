class CategoriesController < ApplicationController
  
  layout "items"
    
  def index
    @highlights = Item.highlights
    @categories = Category.order("priority ASC, title DESC").all
    headers['Cache-Control'] = 'public, max-age=60' # 5 min cache
    headers['Last-Modified'] = Item.last_item.updated_at.httpdate
  end

  def show
    @show_breadcrumb = true
    @category = Category.find(params[:id])
    headers['Cache-Control'] = 'public, max-age=60' # 5 min cache
    headers['Last-Modified'] = @category.items.last_item.updated_at.httpdate
    @items = @category.
      items.
      where(:draft => false).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      page(params[:page]).per(20)
  end

end
