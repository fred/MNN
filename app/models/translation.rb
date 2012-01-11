class Translation < ActiveRecord::Base
  validates_presence_of :key, :value, :locale
end
