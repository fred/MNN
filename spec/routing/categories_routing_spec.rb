require "spec_helper"

describe CategoriesController do
  describe "routing" do

    it "routes to #index" do
      expect(get("/categories")).to route_to("categories#index")
    end

    it "routes to #show" do
      expect(get("/categories/1")).to route_to("categories#show", id: "1")
    end

    it "routes to #show.rss" do
      expect(get("/categories/1.rss")).to route_to("categories#show", id: "1", format: "rss")
    end

    it "routes to #show.atom" do
      expect(get("/categories/1.atom")).to route_to("categories#show", id: "1", format: "atom")
    end

  end
end
