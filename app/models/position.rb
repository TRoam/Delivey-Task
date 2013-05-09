class Position < ActiveRecord::Base
  # attr_accessible :title, :body
    attr_accessible :role_id,:person_id,:teaminfo_id, :projectinfo_id, :taktinfo_id
    
  belongs_to  :role
  belongs_to  :user
  belongs_to  :teaminfo
  belongs_to  :peojectinfo
  belongs_to  :taktinfo
  belongs_to  :testplan
end
