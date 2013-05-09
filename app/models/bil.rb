class Bil < ActiveRecord::Base
   attr_accessible :issue_key,:issue_type,:summary,:version_id,:version_name,:priority,:assignee,:reporter,:status,:project_key,:project_id,:project_name,:descript
end
