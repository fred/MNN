require "spec_helper"

describe LanguagesController do
  describe "routing" do

    it "routes to #index" do
      get("/languages").should route_to("languages#index")
    end

    it "routes to #show" do
      get("/languages/1").should route_to("languages#show", :id => "1")
    end

  end
end
