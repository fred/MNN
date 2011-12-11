class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.text :description
      t.references :attachable

      t.timestamps
    end
    add_index :attachments, :attachable_id
  end
end
