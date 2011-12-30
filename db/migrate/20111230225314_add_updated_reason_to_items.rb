class AddUpdatedReasonToItems < ActiveRecord::Migration
  def change
    add_column :items, :updated_reason, :string
  end
end
