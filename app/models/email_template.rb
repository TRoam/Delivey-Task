class EmailTemplate < ActiveRecord::Base
  attr_accessible :content, :name,:subject
  validates :name, :content, :subject, :presence => true
end
