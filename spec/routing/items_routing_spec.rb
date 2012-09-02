require "spec_helper"

describe ItemsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/items")).to route_to("items#index")
    end

    it "routes to #new" do
      expect(get("/items/new")).to route_to("items#new")
    end

    it "routes to #show" do
      expect(get("/items/1")).to route_to("items#show", id: "1")
    end
    
    it "routes to #index.rss" do
      expect(get("/rss")).to route_to("items#index", format: "rss")
    end
    it "routes to #index.atom" do
      expect(get("/atom")).to route_to("items#index", format: "atom")
    end
  end
end
