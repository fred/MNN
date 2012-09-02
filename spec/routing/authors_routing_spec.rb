require "spec_helper"

describe AuthorsController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/authors")).to route_to("authors#index")
    end

    it "routes to #show" do
      expect(get("/authors/1")).to route_to("authors#show", id: "1")
    end

    it "routes to #show.rss" do
      expect(get("/authors/1.rss")).to route_to("authors#show", id: "1", format: "rss")
    end

    it "routes to #show.atom" do
      expect(get("/authors/1.atom")).to route_to("authors#show", id: "1", format: "atom")
    end

  end
end
