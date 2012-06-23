# encoding: utf-8
class ImageUploader < BaseImageUploader

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mini do
    process resize_to_fit: [32, 32]
  end
  version :thumb do
    process resize_to_fit: [64, 64]
  end
  version :small do
    process resize_to_fill: [100, 100]
  end
  version :medium do
    process resize_to_fit: [240, 240]
  end
  version :main do
    process resize_to_fill: [300, 300]
  end
  version :large do
    process resize_to_fit: [400, 400]
  end
  version :full do
    process resize_to_fit: [600, 600]
  end
  
end
