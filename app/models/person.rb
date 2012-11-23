class Person < ActiveRecord::Base
  attr_accessible :responsibleperson
  has_many :objectresponsibles
  has_many :components
  has_many :checkmen  ,:through => :objectresponsibles
end
