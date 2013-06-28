# encoding: utf-8
class BaseImageUploader < BaseUploader
  include CarrierWave::MiniMagick
  
  process quality: 90

  process :set_content_type

  def extension_white_list
    %w(jpg jpeg gif png tiff)
  end

end