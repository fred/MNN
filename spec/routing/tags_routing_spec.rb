require "spec_helper"

describe TagsController do
  describe "routing" do

    it "routes to #index" do
      get("/tags").should route_to("tags#index")
    end

    it "routes to #show" do
      get("/tags/1").should route_to("tags#show", :id => "1")
    end

  end
end
