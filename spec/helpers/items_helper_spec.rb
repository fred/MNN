require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ContactsHelper. For example:
#
# describe ContactsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ItemsHelper do
  # pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @item = FactoryGirl.create(:item)
  end

  describe "Twitter Link" do
    it "Gives twitter page Link" do
      helper.twitter_link.should == "https://twitter.com/#/worldmathaba"
    end
  end
end
