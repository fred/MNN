class AuthorsController < ApplicationController
  
  def index
    @authors = User.order("id ASC").page(params[:page], per_page: 20)
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
    
    @rss_title = "World Mathaba - Items from #{@author.name} (#{@author.email})"
    @rss_description = "World Mathaba - Items from #{@author.name} (#{@author.email})"
    @rss_category = "author_#{@author.name}"
    @rss_source = author_path(@author, only_path: false, protocol: 'https')
    @rss_language = "en"
    
    respond_to do |format|
      format.html
      format.atom { render partial: "/shared/items", layout: false }
      format.rss  { render partial: "/shared/items", layout: false }
      format.json { render json: @items }
      format.xml { render @items }
    end
  end
  
end
