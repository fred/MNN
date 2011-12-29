class TagsController < ApplicationController
  
  layout "items"
  
  def index
  end

  def show
    @show_breadcrumb = true
    @tag = Tag.find(params[:id])
    # @items = @category.published_items.paginate(per_page: 20, page: params[:page])
    @items = @tag.
      items.
      where(:draft => false).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      page(params[:page]).per(20)
  end

end
