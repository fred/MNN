class Version < ActiveRecord::Base

  after_create  :cleanup_versions

  def self.versions_to_keep
    # Setting.versions_to_keep || 200
    200
  end

  # Cleanup database versions table (vestal_versions)
  def cleanup_versions
    if Version.count > Version.versions_to_keep
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
    limit(self.count-Version.versions_to_keep).
    destroy_all
  end

end