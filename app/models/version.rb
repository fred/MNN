class Version < ActiveRecord::Base
  VERSIONS_TO_KEEP = 200

  after_create  :cleanup_versions

  # Cleanup database versions table (vestal_versions)
  def cleanup_versions
    if Version.count > VERSIONS_TO_KEEP
      if Rails.env.production?
        Version.delay.delete_old
      else
        Version.delete_old
      end
    end
  end

  def self.delete_old
    self.select("id,created_at").
    order("id ASC").
    limit(self.count-VERSIONS_TO_KEEP).
    destroy_all
  end


end