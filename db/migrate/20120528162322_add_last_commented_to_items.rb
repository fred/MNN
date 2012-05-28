class AddLastCommentedToItems < ActiveRecord::Migration
  def change
    add_column :items, :last_commented_at, :datetime
  end
end
