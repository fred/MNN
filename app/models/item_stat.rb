class ItemStat < ActiveRecord::Base
  belongs_to :item, inverse_of: :item_stat

  after_save :touch_item

  # update item every 20 page views
  def touch_item
    if views_counter > 9 && views_counter.modulo(10) == 0
      item.touch
    end
    true
  end

end
