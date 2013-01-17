class CheckmenDatatable
	delegate :params,:h,:link_to, :number_to_current, :check_box_tag,:content_tag,to: :@view

	def initialize(view , checkman)
		@view = view
		@checkman = checkman
	end

	def as_json(options = {})
		{
			sEcho: params[:sEcho].to_i,
		    iTotalRecords: Checkman.count,
		    iTotalDisplayRecords: checkmen.total_entries,
		    aaData: data
		}
	end

private 
	def data
		checkmen.map do |c|
			[

				
				# h('<input id="checkman_ids_" name="checkman_ids[]" type="checkbox" value="#{c.id}">')
				check_box_tag('checkman_ids[]',c.id),
				link_to({:action =>'edit',:id=>c.id,:remote=>true},:class=>"feedback",:id=>c.id) do
					if c.feedback == "open"
						"Open"
					else
						"Addressed"
					end
				end,
				h(c.checkid),
				h(c.messageid),
				h(c.objectresponsible.objectname),
				h(c.priority),
				h(c.release),
				if c.objectresponsible.package.component_id.nil?
					h("-")
				else
					h(c.objectresponsible.package.component.applicationcomponent)
				end,
				h(c.objectresponsible.package.package),
                content_tag(:span,:class=>"person_edit",:id=>c.id) do
                    if c.objectresponsible.person_id
                        c.objectresponsible.person.sapname
                    else
                        "null"
                    end	
                end,
				if c.prodrel == true
					h("YES")
				else
					h("NO")
				end
			]
		end
	end

   def checkmen
      @checkmen ||= fetch_checkmen
   end

  def fetch_checkmen
    checkmen = @checkman.order("#{sort_column} #{sort_direction}")
    checkmen = checkmen.page(page).per_page(per_page)
     # new array to save component/package/object/checkmen/person ids 
    	object_ids = Array.new()
    	package_ids =Array.new()
    	component_ids =Array.new()
    	person_ids =Array.new()
   
        # search checkman att
        # search prodrel
       if params[:sSearch_10].present?
	    	case params[:sSearch_10]
	    	when "All" then checkmen 
	    	else checkmen = checkmen.where(:prodrel => "t")
	    	end
       end

        #search feedback 
        if params[:sSearch_1].present?
        	case params[:sSearch_1]
        	when "open"
        		then checkmen = checkmen.where(:feedback => "open")
        	when "Addressed"
        		then checkmen = checkmen.where(:feedback => "Addressed")
        	end
        end

        #search checkid
        if params[:sSearch_2].present?
        	checkmen = checkmen.where("checkid like :search", search: "%#{params[:sSearch_2]}%")
        end

        # search ,messageid
        if params[:sSearch_3].present?
        	checkmen = checkmen.where("messageid like :search", search: "%#{params[:sSearch_3]}%")
        end
        
        #search priority
        if params[:sSearch_5].present?
        	checkmen = checkmen.where("priority = ?", params[:sSearch_5])
        end

        #search system 
        if params[:sSearch_6].present?
        	checkmen = checkmen.where("release = ?" ,params[:sSearch_6])
        end

        # search object
        if params[:sSearch_4].present?
        	object_ids = Objectresponsible.where("objectname like :search ",search: "%#{params[:sSearch_4]}%").pluck(:id)
        end

    	# search pacages
    	if params[:sSearch_8].present?
    	   package_ids =Package.where("package like :search " ,search: "%#{params[:sSearch_8]}%").pluck(:id)
    	   if object_ids.empty?
    	   	object_ids  =Objectresponsible.where(:package_id => package_ids).pluck(:id)
    	   else
    	   	object_ids  =Objectresponsible.where(:package_ids =>package_ids,:id=>object_ids).pluck(:id)
    	   end
    	end

    	# search components 
    	if params[:sSearch_7].present?
    	   component_ids = Component.where("applicationcomponent like :search" ,search: "%#{params[:sSearch_7]}%").pluck(:id)
    	   if package_ids.empty?
    	   	 package_ids = Package.where(:component_id =>component_ids).pluck(:id)
    	   else
    	   	 package_ids = Package.where(:component_id =>component_ids,:id=>package_ids).pluck(:id)
    	   end
    	   if object_ids.empty?
    	   	object_ids  =Objectresponsible.where(:package_id => package_ids).pluck(:id)
    	   else
    	   	object_ids  =Objectresponsible.where(:package_id =>package_ids,:id=>object_ids).pluck(:id)
    	   end
    	end
    	
        #search sapname
    	if params[:sSearch_9].present?
    		person_ids = Person.where("sapname like :search",search: "%#{params[:sSearch_9]}%").pluck(:id)
    		if object_ids.empty?
    			object_ids = Objectresponsible.where(:person_id => person_ids).pluck(:id)
    		else
    			object_ids = Objectresponsible.where(:person_id => person_ids,:id=>object_ids).pluck(:id)
    		end
    	end
    	if !object_ids.empty?
     	    checkmen = checkmen.where(:objectresponsible_id => object_ids)
		end
    	# if @component.empty?
    	# 	return check
    	# end
    	# @component.each do |c|
    	# 	object <<  c.objectresponsibles
    	# end
    	# if object.empty?
    	# 	return check
    	# end
    	# object.each do |o|
    	# 	o.each do |t|
    	# 	t.checkmen.each do |check_d|
    	# 		check << check_d
    	# 	end
    	#     end
    	# end
    	# checkmen = check

        #search all
	    if params[:sSearch].present?
	      checkmen = checkmen.where("checkid like :search or messageid like :search or release like :search or status like :search or dlm like :search or feedback like :search or prodrel like :search", search: "%#{params[:sSearch]}%")
	    end
	    checkmen
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
     params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 15
  end

  def sort_column
    columns = %w[objectresponsible_id feedback checkid messageid objectresponsible_id priority release component package objectresponsible_id prodrel]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end