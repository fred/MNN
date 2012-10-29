class PagesController < InheritedResources::Base
  
  def show
    @page = Page.find(params[:id])
    private_headers
    headers['Last-Modified'] = @page.updated_at.httpdate if @page
    respond_to do |format|
      format.html
      format.json { render json: @page }
      format.js { render layout: false }
    end
  end
  
  def index
    @pages = Page.active.all
  end
  
end
