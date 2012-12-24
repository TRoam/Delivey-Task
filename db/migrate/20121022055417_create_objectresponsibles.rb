class CreateObjectresponsibles < ActiveRecord::Migration
  def change
    create_table :objectresponsibles do |t|
      t.string :objectname
      t.string :objecttype
      t.string :contact    , :default=>"SAP"
      t.integer :person_id 
      t.integer :package_id

      t.timestamps
    end
  end
end
