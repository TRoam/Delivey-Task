class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :positions 
  has_many :roles , :through => :positions
end
