class Testplan < ActiveRecord::Base
  attr_accessible :taktinfo_id,:plan_name,:test_type,:format,:coverage,:ok_rate,:status,:open_message,:comment,:reporter,:automated
  belongs_to :taktinfo
  has_many :positions
end
