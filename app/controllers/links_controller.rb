class LinksController < ApplicationController

  def index
    @links = Link.order("title ASC")
  end

end
