class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :attachable, polymorphic: true
  belongs_to :existing_attachment, foreign_key: 'parent_id', class_name: "Attachment"
  mount_uploader :image, ImageUploader
end
