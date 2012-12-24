class Package < ActiveRecord::Base
   attr_accessible :package, :component_id
   has_many :objectresponsibles
   belongs_to :component
end
