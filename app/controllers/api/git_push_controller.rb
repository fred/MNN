class Api::GitPushController < ApiController  
  
  # GET: do nothing
  def index
    respond_to do |format|
      format.html {render :text => "OK", :status => 200}
      format.js   {render :text => "OK", :status => 200}
      format.json {render :text => "OK", :status => 200}
    end
  end

  # POST: send email
  def create
    payload = JSON.parse(params[:payload].to_s)
    if Rails.env.production?
      GitQueue.perform_async(payload)
    else
      GitMailer.push_received(payload).deliver
    end
    respond_to do |format|
      format.html {render :text => "OK", :status => 200}
      format.js   {render :text => "OK", :status => 200}
      format.json {render :text => "OK", :status => 200}
    end
  end

end
