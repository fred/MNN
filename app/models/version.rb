class Version < ActiveRecord::Base

  after_create  :cleanup_versions

  def self.versions_to_keep
    if Rails.env.test?
      20
    else
      Settings.versions_to_keep || 300
    end
  end

  def self.versions_threshold
    50
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
    limit(self.count-Version.versions_to_keep+Version.versions_threshold).
    destroy_all
  end

end

Version.module_eval do
  def user
    User.where(id: v.whodunnit).first
  end
end