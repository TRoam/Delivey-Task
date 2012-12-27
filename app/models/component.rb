class Component < ActiveRecord::Base
  attr_accessible :applicationcomponent,:description,:original,:dev_comp_owner,:dev_product_owner,:ims_manager
  has_many :packages
  has_many :objectresponsibles,:through => :packages


def self.upload_component(file)
  spreadsheet = open_spreadsheet(file)
  @upload = Array.new()
  row_number = 0
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    @upload[row_number] = spreadsheet.row(i)
    row_number = row_number+1
  end
  @number = 0
  @upload.each do |i|
  component = Component.find_by_applicationcomponent(i[0])
  if !component 
      component = Component.create(
            :applicationcomponent => i[0],
            :description =>i[1],
            :original  => i[2],
            :dev_comp_owner => i[3],
            :dev_product_owner => i[4],
            :ims_manager  => i[5]
        )
      @number = @number+ 1
    end
  end
  return @number
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