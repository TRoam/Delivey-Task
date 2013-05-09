class CreateProjectinfos < ActiveRecord::Migration
  def change
    create_table :projectinfos do |t|

	    t.string 	:projectID
    	t.string	:description
    	t.string 	:jira
    	
      t.timestamps
    end
  end
end