class Comment < ActiveRecord::Base
  attr_accessible  :commenter, :content,:checkman_id,:feedback
  belongs_to       :checkman
end