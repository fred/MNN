class ItemStat < ActiveRecord::Base
  belongs_to :item, inverse_of: :item_stat
end
