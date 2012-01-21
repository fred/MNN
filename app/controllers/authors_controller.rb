class AuthorsController < ApplicationController
  
  layout "items"
  
  def index
    @authors = User.page(params[:page], :per_page => 20)
    respond_to do |format|
      format.html
      format.json { render json: @authors }
      format.xml { render @authors }
    end
  end
  
  def show
    @show_breadcrumb = true
    @author = User.find(params[:id])
    @items = @author.items.page(params[:page], :per_page => 20)
    
    @rss_title = "Items from #{@author.name} (#{@author.email})"
    @rss_category = "author_#{@author.name}"
    @rss_source = author_path(@author, :only_path => false, :protocol => 'http')
    respond_to do |format|
      format.html
      format.rss
      format.atom
      format.json { render json: @items }
      format.xml { render @items }
    end
  end
  
end
