class CreateCriterions < ActiveRecord::Migration
  def change
    create_table :criterions do |t|

    	t.integer  :teaminfo_id
    	t.integer  :projectinfo_id
    	t.string   :status

      t.timestamps
    end
  end
end
