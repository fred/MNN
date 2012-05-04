require "spec_helper"

describe AuthorsController do
  describe "routing" do

    it "routes to #index" do
      get("/authors").should route_to("authors#index")
    end

    it "routes to #show" do
      get("/authors/1").should route_to("authors#show", id: "1")
    end

    it "routes to #show.rss" do
      get("/authors/1.rss").should route_to("authors#show", id: "1", format: "rss")
    end

    it "routes to #show.atom" do
      get("/authors/1.atom").should route_to("authors#show", id: "1", format: "atom")
    end

  end
end
