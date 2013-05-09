class AddOrgUnitToPeople < ActiveRecord::Migration
   def change
   	  add_column   :people , :orgunit , :string
   end
end