class ErrorsController < ApplicationController
  def error_404
    render layout: 'simple'
  end

  def error_500
    render layout: 'simple'
  end
end
