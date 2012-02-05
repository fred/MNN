class PagesController < InheritedResources::Base
  
  layout "items"
  
  def show
    @page = Page.find(params[:id])
    headers['Cache-Control'] = 'private, max-age=600' # 10 minutes cache
    headers['Last-Modified'] = @page.updated_at.httpdate if @page
  end
  
  def index
    @pages = Page.all
  end
  
end
