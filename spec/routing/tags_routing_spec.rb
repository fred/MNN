require "spec_helper"

describe TagsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/tags")).to route_to("tags#index")
    end

    it "routes to #show" do
      expect(get("/tags/1")).to route_to("tags#show", id: "1")
    end

    it "routes to #show.rss" do
      expect(get("/tags/1.rss")).to route_to("tags#show", id: "1", format: "rss")
    end

    it "routes to #show.atom" do
      expect(get("/tags/1.atom")).to route_to("tags#show", id: "1", format: "atom")
    end

  end
end
