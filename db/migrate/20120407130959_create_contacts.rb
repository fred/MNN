class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :website
      t.string :phone_number
      t.string :mobile_number
      t.string :country
      t.text :notes
      t.integer :user_id

      t.timestamps
    end
  end
end
