class Role < ActiveRecord::Base
  # attr_accessible :title, :body
    attr_accessible :authority, :description, :role

  has_many :positions 
  has_many :users ,:through => :positions
end
