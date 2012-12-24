class Person < ActiveRecord::Base
  attr_accessible :responsibleperson,:eid,:email,:sapname
  has_many :objectresponsibles
  has_many :checkmen  ,:through => :objectresponsibles
end
