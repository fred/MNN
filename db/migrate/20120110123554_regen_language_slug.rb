class RegenLanguageSlug < ActiveRecord::Migration
  def up
    Language.all.each do |lang|
      lang.save
    end
  end

  def down
  end
end
