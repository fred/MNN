require 'spec_helper'

describe ItemStat do
  describe "An ItemStat" do 
    before(:each) do
      @item = FactoryGirl.create(:item)
    end
    it "should have one ItemStat" do
      assert_equal true, @item.item_stat.kind_of?(ItemStat)
    end
    it "should start with count = 0" do
      assert_equal 0, @item.item_stat.views_counter
    end
  end
end
