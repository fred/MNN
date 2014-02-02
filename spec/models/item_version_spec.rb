require 'spec_helper'

describe Item do

  describe "with Version" do
    include ItemSpecHelper
    Sidekiq::Testing.inline!

    it "should create a revision after creating an article" do
      expect(->{ Item.create(valid_item_attributes) }).to change(Version, :count).by(1)
    end
    
    it "should have less than #{Version.versions_to_keep+Version.versions_threshold} revisions in the database" do
      @item = FactoryGirl.create(:item)
      (Version.versions_to_keep+(Version.versions_threshold*2)).times do
        @item.body = Kernel.rand(999).to_s
        @item.save
      end
      expect(Version.count).to less_or_equal(Version.versions_to_keep+Version.versions_threshold)
    end

  end
end
