class TasksController < ApplicationController

  def sitemap
    if current_admin_user && current_admin_user.has_role?(:admin)
      SitemapQueue.perform_in(2.minutes)
      flash[:notice] = "Sitemap Scheduled to run in 2 minutes."
    end

    respond_to do |format|
      format.html {redirect_to root_path}
    end
  end

end
