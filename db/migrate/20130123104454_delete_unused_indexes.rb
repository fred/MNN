class DeleteUnusedIndexes < ActiveRecord::Migration
  def up
    remove_index :items, :locale
    remove_index :items, :updated_by
    remove_index :items, :status_code
    remove_index :items, :allow_comments
    remove_index :items, :allow_star_rating
    remove_index :attachments, :user_id
    remove_index :comments, :approved_by
    remove_index :users, :ranking
    remove_index :pages, :language_id
    remove_index :email_deliveries, :user_id
    remove_index :job_stats, :job_id
    execute "DROP INDEX index_admin_notes_on_resource_type_and_resource_id;"
    execute "DROP INDEX index_active_admin_comments_on_namespace;"
    execute "DROP INDEX index_active_admin_comments_on_author_type_and_author_id;"
  end

  def down
    add_index :items, :locale
    add_index :items, :updated_by
    add_index :items, :status_code
    add_index :items, :allow_comments
    add_index :items, :allow_star_rating
    add_index :attachments, :user_id
    add_index :comments, :approved_by
    add_index :users, :ranking
    add_index :pages, :language_id
    add_index :email_deliveries, :user_id
    add_index :job_stats, :job_id
  end
end
