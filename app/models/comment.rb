class Comment < ActiveRecord::Base
  attr_accessible  :commenter, :content,:checkman_id
  belongs_to       :checkman
end
