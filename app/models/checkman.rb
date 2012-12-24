#encoding: utf-8
class Checkman < ActiveRecord::Base
  attr_accessible :objectname,:status,:foundat,:priority,:checkid,:messageid,:uniqueid,:release,:prodrel,:count,:key,:ncount,:feedback,:comments
  belongs_to :objectresponsible
  has_many   :comments
    def self.upload_to_database(file,temp_release,isp)
      @upload = Array.new
      row_number = 0
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        @upload[row_number] = spreadsheet.row(i)
        row_number = row_number+1
      end
      c = Checkman.limit(1).where("status = ? and release = ?", "open", temp_release)
      if c
        temp_count = c[0].ncount
      else
        temp_count = 0
      end
      @number = 0
      if !@upload.nil?
        @upload.each do |a|
          temp_key  = a[0].to_s + a[1] + a[2] + a[3] + a[4] + a[5] + a[8].to_s + temp_release
          check=Checkman.find_by_key(temp_key)
          #judge if this item is exist
           if check.nil?
                # create and save
              check  = Checkman.new(
                        :foundat => a[7],
                        :priority => a[0],
                        :checkid => a[1],
                        :messageid =>a[2],
                        :uniqueid => a[8],
                        :release => temp_release,
                        :key => temp_key,
                        :ncount => temp_count+1,
                        :prodrel => isp
                                               )
              # bulid comment
              # update object information
               object = Objectresponsible.find_by_objectname(a[3])
                if !object
                    object = Objectresponsible.create(
                      :objectname => a[3],
                      :contact => a[5],
                      :objecttype => a[4],
                      :person_id =>1
                     )
                  
       #update component information
                          component=Component.find_by_package(a[6])
                           if !component
                                component=Component.create(
                                            :package => a[6]
                                           )                
                           end
                          object.component_id = component.id           
                 end
                check.objectresponsible_id = object.id
                #save object_responsible
                
            #save check_man
                check.save
            # record ++
                  @number += 1
           else
                  # this item already exist then do
                  check.status = "open"
                  check.ncount = temp_count + 1
                  check.prodrel = 1
                  check.save
           end
       end
    end 
    # if !@uploadall.nil?
    #     @uploadall.each do |a|
    #       temp_key  = a[0].to_s + a[1] + a[2] + a[3] + a[4] + a[5] + a[8].to_s + temp_release
    #       check=Checkman.find_by_key(temp_key)
    #       #judge if this item is exist
    #        if check.nil?
    #             # create and save
    #           check     = Checkman.new(
    #                     :foundat => a[7],
    #                     :priority => a[0],
    #                     :checkid => a[1],
    #                     :messageid =>a[2],
    #                     :uniqueid => a[8],
    #                     :release => temp_release,
    #                     :key => temp_key,
    #                     :ncount => temp_count+1,
    #                     :prodrel => 0
    #                                            )
    #           # bulid comment
    #           # update object information
    #                  object=Objectresponsible.find_by_objectname(a[3])
    #             if !object
    #                 object = Objectresponsible.new(
    #                   :objectname => a[3],
    #                   :contact => a[5],
    #                   :objecttype => a[4]
    #                  )
    #                   object.person_id = 1
                     
    #    #update component information
    #                       component = Component.find_by_package(a[6])
    #                        if !component
    #                             component=Component.create(
    #                                         :package => a[6]
    #                                        )                
    #                        end
    #                       object.component_id = component.id
    #              end
    #                check.objectresponsible_id = object.id

           
    #             object.save
    #         #save check_man
    #             check.save
            
    #         # record ++
    #               @number += 1
    #        else
    #               # this item already exist then do
    #               check.status = "open"
    #               check.ncount = temp_count + 1
    #               check.prodrel = 0
    #               check.save
    #        end
    #    end
    # end 
    # check how many records ware fixxed
    @fixxednumber  =  0 
    # check conut ,set fixed items' status to "solved"!
	   Checkman.where( "status = 'open' and ncount = ?" , temp_count).each do |p|
	        if p.release ==temp_release
					   p.status = "solved"
					    @fixxednumber += 1
					else
					  p.ncount = temp_count +1
					end
            p.save
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
