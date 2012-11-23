class Objectresponsible < ActiveRecord::Base
  attr_accessible :objectname ,:objecttype,:contact ,:package,:responsible,:component_id,:person_id
  has_many :checkmen
  belongs_to :person
  belongs_to :component
end
