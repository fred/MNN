class AuthorsController < ApplicationController
  
  def index
    @authors = AdminUser.with_articles.order("items_count DESC").page(params[:page], per_page: 20)
    private_headers
    respond_to do |format|
      format.html
      format.json { render json: @authors }
      format.xml { render @authors }
    end
  end
  
  def show
    @show_breadcrumb = true
    @author = User.find(params[:id])
    @items = @author.my_items.localized.page(params[:page], per_page: 20)
    @help_page = Page.where(:slug => "contribute").first

    @language = Language.where(locale: I18n.locale.to_s).first
    
    @rss_title = "World Mathaba - #{@author.public_display_name} #{_('Articles')}"
    @rss_title += " - #{@language.description}" if @language

    @rss_description = "World Mathaba - #{@author.public_display_name} #{_('Articles')}"
    @rss_description += " - #{@language.description}" if @language

    @rss_category = "author_#{@author.id}"
    @rss_source = author_path(@author, only_path: false, protocol: 'https')
    @rss_language = I18n.locale.to_s

    @meta_description = @rss_description
    @meta_title = @rss_title
    @meta_author = @author.public_display_name
    @meta_keywords = "WorldMathaba, news, #{@author.public_display_name}"

    respond_to do |format|
      format.html {
        private_headers
      }
      format.atom {
        public_headers(900)
        render partial: "/shared/items", layout: false
      }
      format.rss {
        public_headers(900)
        render partial: "/shared/items", layout: false
      }
      format.xml { render @items }
    end
  end
  
end
