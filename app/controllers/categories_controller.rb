class CategoriesController < ApplicationController
  
  layout "items"
  
  def index
    @categories = Category.all
    headers['Cache-Control'] = 'public, max-age=300' # 5 min cache
    headers['Last-Modified'] = Item.last_item.updated_at.httpdate
  end

  def show
    @show_breadcrumb = true
    @category = Category.find(params[:id])
    # @items = @category.published_items.paginate(per_page: 20, page: params[:page])
    headers['Cache-Control'] = 'public, max-age=300' # 5 min cache
    @items = @category.
      items.
      where(:draft => false).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      page(params[:page]).per(20)
  end

end
