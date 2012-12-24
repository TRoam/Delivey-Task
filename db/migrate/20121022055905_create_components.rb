class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :softwarecomponent
      t.string :applicationcomponent
      t.text   :description
      t.string :original
      t.string :dev_comp_owner
      t.string :dev_product_owner
      t.string :ims_manager

      t.timestamps
    end
  end
end
