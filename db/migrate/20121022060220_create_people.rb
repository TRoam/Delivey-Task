class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string  :responsibleperson ,:default => "SAP"
      t.integer :eid
      t.string  :email
      t.string  :sapname

      t.timestamps
    end
  end
end
