# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120421083514) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "attachments", :force => true do |t|
    t.string   "image"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "attachable_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "attachable_type"
    t.string   "title"
    t.string   "alt_text"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "index_attachments_on_attachable_id_and_attachable_type"
  add_index "attachments", ["attachable_id"], :name => "index_attachments_on_attachable_id"
  add_index "attachments", ["user_id"], :name => "index_attachments_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "priority",    :default => 10
    t.boolean  "active",      :default => true
    t.string   "slug"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "owner_id",                            :null => false
    t.integer  "commentable_id",                      :null => false
    t.string   "commentable_type",                    :null => false
    t.text     "body",                                :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "user_ip"
    t.string   "user_agent"
    t.integer  "approved_by"
    t.boolean  "approved",         :default => false
    t.boolean  "suspicious",       :default => false
    t.boolean  "marked_spam",      :default => false
  end

  add_index "comments", ["approved"], :name => "index_comments_on_approved"
  add_index "comments", ["approved_by"], :name => "index_comments_on_approved_by"
  add_index "comments", ["marked_spam"], :name => "index_comments_on_marked_spam"
  add_index "comments", ["suspicious"], :name => "index_comments_on_suspicious"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.string   "country"
    t.text     "notes"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "email_deliveries", :force => true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "send_at"
  end

  add_index "email_deliveries", ["item_id"], :name => "index_email_deliveries_on_item_id"
  add_index "email_deliveries", ["user_id"], :name => "index_email_deliveries_on_user_id"

  create_table "item_stats", :force => true do |t|
    t.integer  "item_id"
    t.integer  "views_counter"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.string   "highlight"
    t.text     "body"
    t.text     "abstract"
    t.text     "editor_notes"
    t.string   "slug"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "updated_by"
    t.string   "author_name"
    t.string   "author_email"
    t.string   "article_source"
    t.string   "source_url"
    t.string   "formatting_type",   :default => "HTML"
    t.string   "locale"
    t.string   "meta_keywords"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "status_code",       :default => "draft"
    t.boolean  "draft",             :default => true
    t.boolean  "meta_enabled",      :default => true
    t.boolean  "allow_comments",    :default => true
    t.boolean  "allow_star_rating", :default => true
    t.boolean  "protected_record",  :default => false
    t.boolean  "featured",          :default => false
    t.boolean  "member_only",       :default => false
    t.datetime "published_at"
    t.datetime "expires_on"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "author_status"
    t.datetime "deleted_at"
    t.string   "updated_reason"
    t.integer  "language_id"
    t.string   "keywords"
    t.string   "youtube_id"
    t.boolean  "youtube_vid"
    t.boolean  "youtube_img"
    t.boolean  "sticky",            :default => false
  end

  add_index "items", ["allow_comments"], :name => "index_items_on_allow_comments"
  add_index "items", ["allow_star_rating"], :name => "index_items_on_allow_star_rating"
  add_index "items", ["category_id"], :name => "index_items_on_category_id"
  add_index "items", ["draft"], :name => "index_items_on_draft"
  add_index "items", ["featured"], :name => "index_items_on_featured"
  add_index "items", ["language_id"], :name => "index_items_on_language_id"
  add_index "items", ["locale"], :name => "index_items_on_locale"
  add_index "items", ["member_only"], :name => "index_items_on_member_only"
  add_index "items", ["meta_enabled"], :name => "index_items_on_meta_enabled"
  add_index "items", ["protected_record"], :name => "index_items_on_protected_record"
  add_index "items", ["published_at"], :name => "index_items_on_published_at", :order => {"published_at"=>:desc}
  add_index "items", ["slug"], :name => "index_items_on_slug", :unique => true
  add_index "items", ["status_code"], :name => "index_items_on_status_code"
  add_index "items", ["sticky"], :name => "index_items_on_sticky"
  add_index "items", ["updated_by"], :name => "index_items_on_updated_by"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "languages", :force => true do |t|
    t.string   "locale"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
  end

  add_index "languages", ["locale"], :name => "index_languages_on_locale"
  add_index "languages", ["slug"], :name => "index_languages_on_slug", :unique => true

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "link_title"
    t.string   "slug"
    t.integer  "priority"
    t.integer  "language_id"
    t.integer  "user_id"
    t.boolean  "active"
    t.text     "body"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "pages", ["active"], :name => "index_pages_on_active"
  add_index "pages", ["language_id"], :name => "index_pages_on_language_id"
  add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "scores", :force => true do |t|
    t.integer  "user_id"
    t.integer  "scorable_type"
    t.integer  "scorable_id"
    t.integer  "points"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "scores", ["scorable_id", "scorable_type"], :name => "index_scores_on_scorable_id_and_scorable_type"
  add_index "scores", ["user_id"], :name => "index_scores_on_user_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "shares", :force => true do |t|
    t.integer  "item_id"
    t.boolean  "processed",    :default => false
    t.string   "type"
    t.string   "status"
    t.datetime "processed_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.datetime "enqueue_at"
  end

  add_index "shares", ["item_id", "processed"], :name => "index_shares_on_item_id_and_processed"
  add_index "shares", ["type"], :name => "index_shares_on_type"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "subscriptions", ["item_id"], :name => "index_subscriptions_on_item_id"
  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "taggings", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "tag_id"], :name => "index_taggings_on_taggable_id_and_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "title"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "tags", ["slug"], :name => "index_tags_on_slug", :unique => true
  add_index "tags", ["type"], :name => "index_tags_on_type"

  create_table "translations", :force => true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.text     "bio"
    t.string   "name"
    t.string   "address"
    t.string   "twitter"
    t.string   "diaspora"
    t.string   "skype"
    t.string   "gtalk"
    t.string   "jabber"
    t.string   "phone_number"
    t.string   "time_zone"
    t.integer  "ranking"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "type"
    t.string   "avatar"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["ranking"], :name => "index_users_on_ranking"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["type"], :name => "index_users_on_type"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "ip"
    t.string   "tag"
    t.string   "user_email"
    t.string   "user_agent"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
