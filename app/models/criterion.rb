class Criterion < ActiveRecord::Base
  attr_accessible :teaminfo_id, :projectinfo_id,:status

  belongs_to :teaminfo
  belongs_to :projectinfo

  has_many :taktinfos


end
