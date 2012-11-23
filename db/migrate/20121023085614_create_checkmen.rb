class CreateCheckmen < ActiveRecord::Migration
  def change
    create_table :checkmen do |t|
      t.string  :status , :default => "open"
      t.date    :foundat
      t.integer :priority
      t.string  :checkid
      t.string  :messageid
      t.string  :uniqueid
      t.string  :release
      t.boolean :prodrel, :default => "flase"
      t.string  :dlm , :default => "Drik" 
      t.string  :key
      t.integer :ncount
      t.string  :feedback , :default => "open"
      t.integer :objectresponsible_id
      
      t.timestamps 
   
  end
  end 
  
end