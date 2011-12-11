class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      
      # Strings and TEXT
      t.string  :title
      t.string  :highlight
      t.text    :body, :limit => 16777214 # MEDIUMTEXT => (16MB)
      t.text    :abstract
      t.text    :editor_notes
      
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
      
      t.integer  :status_code,        :default => 2
      
      # Booleans TRUE or FALSE
      t.boolean  :meta_enabled,         :default => true
      t.boolean  :allow_comments,       :default => true
      t.boolean  :allow_star_rating,    :default => true
      t.boolean  :protected_record,   :default => false
      t.boolean  :highlight,          :default => false

      t.datetime :published_at
      t.datetime :expires_on
      t.timestamps
    end
  end
end
