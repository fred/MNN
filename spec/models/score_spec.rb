require 'spec_helper'

describe Score do
  describe "A Score" do 
    before(:each) do
      @score = Factory(:score)
    end
    it "should be valid" do
      assert_equal true, @score.valid?
    end
  end
end
