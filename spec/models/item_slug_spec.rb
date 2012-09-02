require 'spec_helper'

describe Item do

  describe "With slug" do

    before(:each) do
      @item = FactoryGirl.create(:item, title: "The class of 2012")
    end

    it "should have a slug with the item ID" do
      expect(@item.slug).to match("^#{@item.id}")
    end

    it "should have the custom slug" do
      expect(@item.slug).to eq(@item.custom_slug)
    end

  end

end
