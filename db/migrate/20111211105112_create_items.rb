class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      
      # Strings and TEXT
      t.string  :title
      t.string  :highlight
      t.text    :body, :limit => 16777214 # MEDIUMTEXT => (16MB)
      t.text    :abstract
      t.text    :editor_notes
      t.string  :slug
      
      # Foreign Keys
      t.integer  :category_id
      t.integer  :user_id
      t.integer  :updated_by
      
      t.string   :author_name
      t.string   :author_email
      t.string   :article_source
      t.string   :source_url
      t.string   :formatting_type,   :default => "HTML"
      t.string   :locale
      t.string   :meta_keywords
      t.string   :meta_title
      t.string   :meta_description
      
      # Booleans TRUE or FALSE
      t.string   :status_code,          :default => "draft"
      t.boolean  :draft,                :default => true
      t.boolean  :meta_enabled,         :default => true
      t.boolean  :allow_comments,       :default => true
      t.boolean  :allow_star_rating,    :default => true
      t.boolean  :protected_record,     :default => false
      t.boolean  :featured,             :default => false
      t.boolean  :member_only,          :default => false

      t.datetime :published_at
      t.datetime :expires_on
      t.timestamps
    end
    # INDEXES
    add_index :items, :slug, :unique => true
    add_index :items, :draft
    add_index :items, :locale
    add_index :items, :user_id
    add_index :items, :updated_by
    add_index :items, :category_id
    add_index :items, :status_code
    add_index :items, :meta_enabled
    add_index :items, :allow_comments
    add_index :items, :allow_star_rating
    add_index :items, :protected_record
    add_index :items, :featured
    add_index :items, :member_only
  end
end
