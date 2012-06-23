# encoding: utf-8
class AvatarUploader < BaseImageUploader

  def store_dir
    "uploads/users/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/assets/mini_logo.png"
  end

  version :mini do
    process resize_to_fit: [30, 30]
  end
  version :thumb do
    process resize_to_fit: [50, 50]
  end
  version :small do
    process resize_to_fit: [80, 80]
  end
  version :medium do
    process resize_to_fit: [160, 160]
  end

end
