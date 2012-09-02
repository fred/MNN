require 'spec_helper'

describe Item do
  include NumericMatchers

  it 'should respond to existing_image_id' do
    expect(Item.new).to respond_to(:existing_attachment_id)
  end

  describe "With existing_attachment_id" do
    include ItemSpecHelper

    before(:each) do
      @attachment = FactoryGirl.create(:attachment)
      @item = FactoryGirl.create(:item, existing_attachment_id: @attachment.id)
    end

    it 'should have an image attachment' do
      expect(@item.attachments.count).to eq(1)
    end

    it 'should have 2 attachments in the database' do
      expect(Attachment.count).to eq(2)
    end

    # Only for test environment
    it 'should have the same attachment image' do
      expect((File.exists?(@item.main_image.image.path))).to eq(true)
    end

  end

end