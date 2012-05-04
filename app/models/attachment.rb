class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :attachable, polymorphic: true
  mount_uploader :image, ImageUploader
end
