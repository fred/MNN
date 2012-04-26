require 'spec_helper'

describe Language do
  describe "A Language" do 
    before(:each) do
      @language = FactoryGirl.create(:language)
    end
    it "should be valid" do
      assert_equal true, @language.valid?
    end
    it "should require locale" do
      @language.locale = nil
      assert_equal false, @language.valid?
    end
    it "should require description" do
      @language.description = nil
      assert_equal false, @language.valid?
    end
    it "should require unique locale" do
      new_locale = Language.new(:locale => @language.locale, :description => "blah blah")
      assert_equal false, new_locale.valid?
    end
  end
end
