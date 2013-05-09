class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
    	    	t.integer	:role_id
    	t.integer 	:user_id
    	t.integer   :teaminfo_id
    	t.integer 	:projectinfo_id
    	t.integer   :taktinfo_id
    	t.integer   :testplan_id
      t.timestamps
    end
  end
end
