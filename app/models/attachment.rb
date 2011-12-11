class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :attachable
  mount_uploader :image, ImageUploader
end
