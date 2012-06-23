# encoding: utf-8
class BaseImageUploader < BaseUploader
  include CarrierWave::MiniMagick
  
  process quality: 92

  process :set_content_type

  # Set Watermark
  # process watermark: "#{Rails.root}/public/watermark.png"

  def extension_white_list
    %w(jpg jpeg gif png tiff)
  end

  protected

  def watermark(path_to_file)
    manipulate! do |img|
      img = img.composite(MiniMagick::Image.open(path_to_file), "jpg") do |c|
        c.gravity "South"
      end
    end
  end

end