class AddFisrstNameToPeople < ActiveRecord::Migration
  def change
  	add_column    :people , :lastname  , :string
  	add_column    :people , :firstname , :string
  	remove_column :people , :responsibleperson
  end
end
