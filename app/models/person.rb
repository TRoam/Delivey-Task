class Person < ActiveRecord::Base
  attr_accessible :firstname,:lastname,:eid,:email,:sapname,:orgunit,:ims
  has_many :objectresponsibles
  has_many :checkmen  ,:through => :objectresponsibles
end