#encoding: utf-8
class Checkman < ActiveRecord::Base
  attr_accessible :objectname,:status,:foundat,:priority,:checkid,:messageid,:uniqueid,:release,:prodrel,:count,:key,:ncount,:feedback,:comments
  belongs_to :objectresponsible
  has_many   :comments

    def self.upload_to_database(uploadall,uploadrel,temp_release)
	    @uploadrel = uploadrel
      @uploadall = uploadall
      c = Checkman.where(:first,
        :conditions => ["status = 'open' and release = ?, temp_release"]
                        )
      if !c
        temp_count = c.ncount
      else
        temp_count = 0
      end
      @number = 0
      if !@uploadrel.nil?
        @uploadrel.each do |a|
          temp_key  = a[0].to_s + a[1] + a[2] + a[3] + a[4] + a[5] + a[8].to_s + temp_release
          check=Checkman.find_by_key(temp_key)
          #judge if this item is exist
           if check.nil?
                # create and save
              check     = Checkman.new(
                        :foundat => a[7],
                        :priority => a[0],
                        :checkid => a[1],
                        :messageid =>a[2],
                        :uniqueid => a[8],
                        :release => temp_release,
                        :key => temp_key,
                        :ncount => temp_count+1,
                        :prodrel => 1
                                               )
              # bulid comment
              # update object information
                     object=Objectresponsible.find_by_objectname(a[3])
                if !object
                    object = Objectresponsible.new(
                      :objectname => a[3],
                      :contact => a[5],
                      :objecttype => a[4]
                     )
                       object.person_id = 1
                      check.objectresponsible_id = object.id
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
            self.transaction do
                object.save
            #save check_man
                check.save
            end
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
    if !@uploadall.nil?
        @uploadall.each do |a|
          temp_key  = a[0].to_s + a[1] + a[2] + a[3] + a[4] + a[5] + a[8].to_s + temp_release
          check=Checkman.find_by_key(temp_key)
          #judge if this item is exist
           if check.nil?
                # create and save
              check     = Checkman.new(
                        :foundat => a[7],
                        :priority => a[0],
                        :checkid => a[1],
                        :messageid =>a[2],
                        :uniqueid => a[8],
                        :release => temp_release,
                        :key => temp_key,
                        :ncount => temp_count+1,
                        :prodrel => 0
                                               )
              # bulid comment
              # update object information
                     object=Objectresponsible.find_by_objectname(a[3])
                if !object
                    object = Objectresponsible.new(
                      :objectname => a[3],
                      :contact => a[5],
                      :objecttype => a[4]
                     )
                      object.person_id = 1
                      check.objectresponsible_id = object.id
       #update component information
                          component = Component.find_by_package(a[6])
                           if !component
                                component=Component.create(
                                            :package => a[6]
                                           )                
                           end
                          object.component_id = component.id
                 end
                   check.objectresponsible_id = object.id

            self.transaction do
                object.save
            #save check_man
                check.save
            end
            # record ++
                  @number += 1
           else
                  # this item already exist then do
                  check.status = "open"
                  check.ncount = temp_count + 1
                  check.prodrel = 0
                  check.save
           end
       end
    end 
    # check how many records ware fixxed
    @fixxednumber  =  0 
    # check conut ,set fixed items' status to "solved"!
	   Checkman.where(:all,:conditions => ["status = 'open' and count = ?",temp_count]).each do |p|
	         p.status = "solved"
	         p.comment.feedback = "solved"
	         @fixxednumber += 1
	   end
	end
end
