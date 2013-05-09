class CreateTeaminfos < ActiveRecord::Migration
  def change
    create_table :teaminfos do |t|
    	
    	t.string 	:team_name
      t.text    :description

      t.timestamps
    end
  end
end
