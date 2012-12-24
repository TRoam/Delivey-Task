class Comment < ActiveRecord::Base
  attr_accessible  :commenter, :content,:checkman_id
  belongs_to       :checkman


def self.upload_component(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    component = find_by_id(row["Appl.Component"]) || new
    component.attributes = row.to_hash.slice(*accessible_attributes)
    component.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Csv.new(file.path, nil, :ignore)
  when ".CSV" then Csv.new(file.path,nil, :ignore)
  when ".xls" then Excel.new(file.path, nil, :ignore)
  when ".XLS" then Csv.new(file.path,nil, :ignore)
  when ".xlsx" then Excelx.new(file.path, nil, :ignore)
  when ".XLSX" then Csv.new(file.path,nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end

end