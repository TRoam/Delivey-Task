class EmailTemplate < ActiveRecord::Base
  attr_accessible :content, :name
  validates :name, :content, :presence => true
end
