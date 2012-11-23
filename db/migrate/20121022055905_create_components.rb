class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :package
      t.string :softwarecomponent
      t.string :applicationcomponent
      t.date   :changeon
      t.string :changeperson

      t.timestamps
    end
  end
end
