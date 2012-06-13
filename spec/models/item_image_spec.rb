require 'spec_helper'

describe Item do
  include NumericMatchers

  it 'should respond to existing_image_id' do
    Item.new.should respond_to(:existing_attachment_id)
  end

  describe "With existing_attachment_id" do
    include ItemSpecHelper

    before(:each) do
      @attachment = FactoryGirl.create(:attachment)
      @item = FactoryGirl.create(:item, existing_attachment_id: @attachment.id)
    end

    it 'should have an image attachment' do
      @item.attachments.count.should eq(1)
    end

    it 'should have 2 attachments in the database' do
      Attachment.count.should eq(2)
    end

    # Only for test end
    it 'should have the same attachment image' do
      (File.exists?(@item.main_image.image.path)).should eq(true)
    end

  end

end