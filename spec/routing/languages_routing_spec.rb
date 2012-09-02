require "spec_helper"

describe LanguagesController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/languages")).to route_to("languages#index")
    end

    it "routes to #show" do
      expect(get("/languages/1")).to route_to("languages#show", id: "1")
    end

  end
end
