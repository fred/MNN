class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.text :description
      t.integer :user_id
      t.references :attachable

      t.timestamps
    end
    add_index :attachments, :attachable_id
    add_index :attachments, :user_id
  end
end
