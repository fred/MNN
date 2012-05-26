class UpdateItemsCommentsCounter < ActiveRecord::Migration
  def up
    ids = Comment.where("commentable_id is not NULL").
      where(commentable_type: "Item").
      order("commentable_id ASC").
      select("commentable_id").
      map{|t| t.commentable_id }.uniq
    say_with_time "Updating existing comments_count for items" do
      Item.find(ids).each do |item|
        # Item.reset_counters item.id, :comments
        item.update_column(:comments_count, item.comments.count)
      end
    end
  end

  def down
  end
end
