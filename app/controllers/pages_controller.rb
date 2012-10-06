class PagesController < InheritedResources::Base
  
  def show
    @page = Page.find(params[:id])
    headers['Cache-Control'] = 'private, max-age=3600' # 1 hour
    headers['Last-Modified'] = @page.updated_at.httpdate if @page
    respond_to do |format|
      format.html
      format.json { render json: @page }
      format.js { render layout: false }
    end
  end
  
  def index
    @pages = Page.all
  end
  
end
