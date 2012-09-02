require 'spec_helper'

describe Item do

  describe "with Version" do
    include ItemSpecHelper
    require 'sidekiq/testing/inline'

    it "should create a revision after creating an article" do
      expect(->{ Item.create(valid_item_attributes) }).to change(Version, :count).by(1)
    end
    
    it "should keep a maximum of #{Version.versions_to_keep} revisions in the database" do
      @item = FactoryGirl.create(:item)
      (Version.versions_to_keep+10).times do
        @item.body = Kernel.rand(999).to_s
        @item.save
      end
      expect(Version.count).to eq(Version.versions_to_keep)
    end

  end
end
