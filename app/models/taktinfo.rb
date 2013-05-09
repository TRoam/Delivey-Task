class Taktinfo < ActiveRecord::Base
  attr_accessible :taktID,:start_time,:end_time,:criterion_id,:reporter
  
  belongs_to :criterion
  has_many   :testplans
  has_many :positions
end
