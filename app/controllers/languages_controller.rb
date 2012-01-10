class LanguagesController < ApplicationController
  
  layout "items"
  
  def index
    @languages = Language.all
  end

  def show
    @show_breadcrumb = true
    @language = Language.find(params[:id])
    redirect_to language_items_path(@language)
  end

end
