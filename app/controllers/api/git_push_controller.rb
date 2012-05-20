class Api::GitPushController < ApiController  
  
  # POST
  def create
    push = JSON.parse(params[:payload].to_s)
    # push = params[:payload].to_s
    respond_to do |format|
      format.html {render text: push}
      format.js
      format.json {render text: push}
    end
  end

end

# curl -i -H "Accept: application/json" \
#   -H "X-HTTP-Method-Override: POST" \
#   -X POST -d "payload: { id: \"hello\" }" http://mathaba.dev/api/git
