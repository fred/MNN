class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :attachable, polymorphic: true, touch: true
  belongs_to :existing_attachment, foreign_key: 'parent_id', class_name: "Attachment", touch: true
  mount_uploader :image, ImageUploader
  has_paper_trail :on => [:edit, :destroy]
end
