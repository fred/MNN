class JobStat < ActiveRecord::Base
  
  belongs_to :processable, polymorphic: true
  
end
