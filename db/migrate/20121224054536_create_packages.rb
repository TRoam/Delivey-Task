class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :package 
      t.string :owner
      t.integer :component_id

      t.timestamps
    end
  end
end
