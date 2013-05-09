class Projectinfo < ActiveRecord::Base
  attr_accessible :projectID, :description ,:jira
  has_many  :criterions
  has_many  :teaminfos, :through => :criterions
  has_many :positions
end
