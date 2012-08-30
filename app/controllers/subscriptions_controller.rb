class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @subscriptions = current_user.comment_subscriptions
    flash[:notice] = "You don't have any subscriptions." if @subscriptions.empty?
  end

  def destroy
    @subscription = current_user.comment_subscriptions.find(params[:id])
    if @subscription && @subscription.destroy
      flash[:notice] = ("Successfully Removed Subscription")
    end
    respond_to do |format|
      format.html {redirect_to subscriptions_path}
      format.json
      format.js
    end
  end

end
