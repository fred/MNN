class RegenImages < ActiveRecord::Migration
  def up
    Attachment.all.each do |at|
      # at.image.recreate_versions!
    end
  end

  def down
  end
end
