class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string  :responsibleperson 
      t.integer :eid
      t.string  :email
      t.string  :sapname   , :default => "SAP"

      t.timestamps
    end
  end
end
