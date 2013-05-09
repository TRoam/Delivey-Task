class CreateTestplans < ActiveRecord::Migration
  def change
    create_table :testplans do |t|
		t.string  :plan_name
    	t.string  :type
    	t.string  :coverage
    	t.string  :ok_rate
    	t.string  :status
    	t.integer :open_message
    	t.text    :comment
    	t.integer :taktinfo_id
      t.integer :format
      t.boolean :automated
      t.timestamps
    end
  end
end
