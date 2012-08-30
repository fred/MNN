class DropTranslations < ActiveRecord::Migration
  def up
    drop_table :translations
  end

  def down
    create_table "translations", :force => true do |t|
      t.string   "locale"
      t.string   "key"
      t.text     "value"
      t.text     "interpolations"
      t.boolean  "is_proc",        :default => false
      t.datetime "created_at",                        :null => false
      t.datetime "updated_at",                        :null => false
    end
  end
end
