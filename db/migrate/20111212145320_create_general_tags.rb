class CreateGeneralTags < ActiveRecord::Migration
  def change
    Tag.where(:type => nil).update_all(:type => "GeneralTag")
  end
end
