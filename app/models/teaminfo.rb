class Teaminfo < ActiveRecord::Base
  attr_accessible :team_name,:description,:jira,:po,:qm,:scrum_master,:sponsor_manager
  has_many :criterions
  has_many :projectinfos ,:through => :criterions

  has_many :positions
end
