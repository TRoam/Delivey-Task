class AddImsToPeople < ActiveRecord::Migration
   def change
   	  add_column   :people , :ims , :string
   end
end