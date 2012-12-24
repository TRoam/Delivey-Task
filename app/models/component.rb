class Component < ActiveRecord::Base
  attr_accessible :softwarecomponent,:applicationcomponent,:description,:original,:dev_comp_owner,:dev_product_owner,:ims_manager
  has_many :packages
  has_many :objectresponsibles,:through => :packages
end