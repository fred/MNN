class UpdateUserItemsCounter < ActiveRecord::Migration

  def up
    ids = Item.where("user_id is not NULL").
      order("user_id ASC").
      select("user_id").
      map{|t| t.user_id }.uniq
    say_with_time "Updating existing items_count for users" do
      User.find(ids).each do |user|
        User.reset_counters user.id, :items
      end
    end
  end

  def down
  end
end
