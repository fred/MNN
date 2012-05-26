class LanguagesController < ApplicationController
  
  def index
    @languages = Language.with_articles
  end

  def show
    @show_breadcrumb = true
    @language = Language.find(params[:id])
    redirect_to language_items_path(@language)
  end

end
