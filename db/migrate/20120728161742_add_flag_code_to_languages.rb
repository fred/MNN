class AddFlagCodeToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :flag_code, :string
  end
end
