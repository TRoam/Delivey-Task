class CreateBils < ActiveRecord::Migration
  def change
    create_table :bils do |t|
    	
    	t.string :issue_key
    	t.string :issue_type
    	t.string :summary
    	t.string :version_id
    	t.string :version_name
    	t.string :priority
    	t.string :assignee
    	t.string :reporter
    	t.string :status
    	t.text   :descript
    	t.string :project_key
    	t.string :project_id
    	t.string :project_name

      t.timestamps
    end
  end
end
