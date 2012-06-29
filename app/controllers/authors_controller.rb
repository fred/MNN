class AuthorsController < ApplicationController
  
  def index
    @authors = AdminUser.order("items_count DESC").page(params[:page], per_page: 20)
    respond_to do |format|
      format.html
      format.json { render json: @authors }
      format.xml { render @authors }
    end
  end
  
  def show
    @show_breadcrumb = true
    @author = User.find(params[:id])
    @items = @author.my_items.page(params[:page], per_page: 20)
    @help_page = Page.where(:slug => "contribute").first
    
    @rss_title = "World Mathaba - Items from #{@author.public_display_name}"
    @rss_description = "World Mathaba - Items from #{@author.public_display_name}"
    @rss_category = "author_#{@author.id}"
    @rss_source = author_path(@author, only_path: false, protocol: 'https')
    @rss_language = "en"

    @meta_description = @rss_description
    @meta_title = @rss_title
    @meta_author = @author.public_display_name
    @meta_keywords = "WorldMathaba, news, #{@author.public_display_name}"
    
    respond_to do |format|
      format.html
      format.atom { render partial: "/shared/items", layout: false }
      format.rss  { render partial: "/shared/items", layout: false }
      format.json { render json: @items }
      format.xml { render @items }
    end
  end
  
end
