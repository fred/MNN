require 'spec_helper'

describe Item do

  describe "with Version" do
    include ItemSpecHelper
    require 'sidekiq/testing/inline'

    it "should create a revision after creating an article" do
      ->{ Item.create(valid_item_attributes) }.should change(Version, :count).by(1)
    end
    
    it "should keep a maximum of #{Version::VERSIONS_TO_KEEP} revisions in the database" do
      @item = FactoryGirl.create(:item)
      (Version::VERSIONS_TO_KEEP+10).times do
        @item.body = Kernel.rand(999).to_s
        @item.save
      end
      Version.count.should eq(Version::VERSIONS_TO_KEEP)
    end

  end
end
