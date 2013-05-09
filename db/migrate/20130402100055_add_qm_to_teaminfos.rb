class AddQmToTeaminfos < ActiveRecord::Migration
  def change
  	add_column :teaminfos, :qm, :string
  	add_column :teaminfos, :po, :string
  	add_column :teaminfos, :scrum_master , :string
  	add_column :teaminfos,:sponsor_manager , :string
  	add_column :taktinfos, :reporter ,  :string
  	add_column :testplans, :reporter ,  :string
  end
end
