class Component < ActiveRecord::Base
  attr_accessible :package ,:softwarecomponent,:applicationcomponent,:changeon,:changeperson
  has_many :objectresponsibles
  has_many :checkmen ,:through => :objectresponsibles

  validates_presence_of :package
end
