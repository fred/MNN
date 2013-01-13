class Share < ActiveRecord::Base

  has_paper_trail :on => [:destroy]

end
