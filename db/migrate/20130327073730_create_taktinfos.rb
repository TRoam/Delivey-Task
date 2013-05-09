class CreateTaktinfos < ActiveRecord::Migration
  def change
    create_table :taktinfos do |t|
    	t.string	:taktID
    	t.date :start_time
    	t.date :end_time
    	t.integer    :criterion_id
      t.timestamps
    end
  end
end
