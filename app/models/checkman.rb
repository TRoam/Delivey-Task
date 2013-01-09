#encoding: utf-8
class Checkman < ActiveRecord::Base
  attr_accessible :objectname,:status,:foundat,:priority,:checkid,:messageid,:uniqueid,:release,:prodrel,:count,:key,:ncount,:feedback,:comments
  belongs_to :objectresponsible

  has_many   :comments
  def self.upload_to_database(file,temp_release,isp)

      # read upload file
      spreadsheet = open_spreadsheet(file)

      # get ncount
      c = Checkman.limit(1).where("status = ? and release = ? ", "open", temp_release)
      if c.blank?
        temp_count = 0
      else
        temp_count = c[0].ncount
      end

      # @number of excel
      @number = 0


      # do insert into database
      (2..spreadsheet.last_row).each do |i|

        temp_key  = spreadsheet.row(i)[0].to_s + spreadsheet.row(i)[1] + spreadsheet.row(i)[2] + spreadsheet.row(i)[3] + spreadsheet.row(i)[4] + spreadsheet.row(i)[5] + spreadsheet.row(i)[8].to_s + temp_release
        #judge if this item is exist
        check = Checkman.find_by_key(temp_key)

        if check.nil?
          return 231
          #then this item is new and insert it to database
          check = Checkman.new(
                    :foundat   => spreadsheet.row(i)[7],
                    :priority  => spreadsheet.row(i)[0],
                    :checkid   => spreadsheet.row(i)[1],
                    :messageid => spreadsheet.row(i)[2],
                    :uniqueid  => spreadsheet.row(i)[8],
                    :release   => temp_release,
                    :key       => temp_key,
                    :ncount    => temp_count+1,
                    :prodrel   => isp.to_i
                               )

          #update object information
          object = object = Objectresponsible.find_by_objectname(spreadsheet.row(i)[3])
            if !object
              object =Objectresponsible.create(
                      :objectname => spreadsheet.row(i)[3],
                      :contact    => spreadsheet.row(i)[5],
                      :objecttype => spreadsheet.row(i)[4]
                )
              person = Person.find_by_responsibleperson(spreadsheet.row(i)[5])
                if !person
                        person = Person.create(
                          :responsibleperson => spreadsheet.row(i)[5]
                          )
                 end
                object.person_id = person.id
                package =Package.find_by_package(spreadsheet.row(i)[6])
                 if !package
                      package=Package.create(
                              :package => spreadsheet.row(i)[6]
                                 )
                 end
                object.package_id = package.id 

                #save object_responsible
                object.save    
            end

            check.objectresponsible_id = object.id           
            #save check_man
                check.save
            # record ++
                  @number += 1
        else
            # this item already exist then do
            if isp.to_i ==1
              check.prodrel = true
            end
            check.status = "open"
            check.ncount = temp_count + 1
            check.save   
        end
      end
   @fixxednumber  =  0 
    # check conut ,set fixed items' status to "solved"!
    Checkman.where( "status = 'open' and release = ? and ncount = ?" ,temp_release, temp_count).each do |p|
        p.status = "solved"
        p.save
        @fixxednumber += 1
    end

	   result_import = Array.new
	   result_import[0] =@fixxednumber
	   result_import[1] =@number
     return result_import
	 end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
     when ".csv"  then Csv.new(file.path, nil, :ignore)
     when ".CSV"  then Csv.new(file.path, nil, :ignore)
     when ".xls"  then Excel.new(file.path, nil, :ignore)
     when ".XLS"  then Excel.new(file.path,nil,:ignore)
     when ".xlsx" then Excel.new(file.path,nil,:ingore)
     when ".XLSX" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
  end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |checkman|
        csv << checkman.attributes.values_at(*column_names)
      end
    end
  end
end
