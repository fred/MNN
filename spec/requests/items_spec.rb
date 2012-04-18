require 'spec_helper'

describe "Items" do
  describe "GET /items" do
    it "should render index" do
      get items_path
      response.status.should be(200)
    end
  end
  describe "GET /rss" do
    it "should render index as RSS feed" do
      get items_rss_path
      response.status.should be(200)
    end
  end
  describe "GET /atom" do
    it "should render index as ATOM feed" do
      get items_atom_path
      response.status.should be(200)
    end
  end
end
