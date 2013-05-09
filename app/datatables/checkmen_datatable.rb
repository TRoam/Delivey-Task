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
                h(c.release),
                if c.objectresponsible.package.component_id.nil?
                    h("-")
                else
                    h(c.objectresponsible.package.component.applicationcomponent)
                end,
                h(c.objectresponsible.package.package),
                h(c.objectresponsible.objectname),
                h(c.priority),
				h(c.checkid),
				h(c.messageid),
                content_tag(:span,:class=>"person_edit",:id=>c.id) do
                    if c.objectresponsible.person_id&&c.objectresponsible.person.firstname.present?
                        h(c.objectresponsible.person.firstname+" "+c.objectresponsible.person.lastname)
                    else
                        content_tag(:i,:class=>"icon-pencil") do
                        end
                    end	
                end,
                if c.objectresponsible.person_id
                        c.objectresponsible.person.ims
                end ,
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
        @outher = 0
        # search checkman att
        # search prodrel
       if params[:sSearch_11].present?
	    	case params[:sSearch_11]
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
        if params[:sSearch_7].present?
        	checkmen = checkmen.where("checkid like :search", search: "%#{params[:sSearch_7]}%")
        end

        # search ,messageid
        if params[:sSearch_8].present?
        	checkmen = checkmen.where("messageid like :search", search: "%#{params[:sSearch_8]}%")
        end
        
        #search priority
        if params[:sSearch_6].present?
        	checkmen = checkmen.where("priority = ?", params[:sSearch_6])
        end

        #search system 
        if params[:sSearch_2].present?
        	checkmen = checkmen.where("release = ?" ,params[:sSearch_2])
        end

        # search object
        if params[:sSearch_5].present?
        	object_ids = Objectresponsible.where("objectname like :search ",search: "%#{params[:sSearch_5]}%").pluck(:id)
            @outher = 1
        end

    	# search pacages
    	if params[:sSearch_4].present?
    	   package_ids =Package.where("package like :search " ,search: "%#{params[:sSearch_4]}%").pluck(:id)
    	   if object_ids.empty?
    	   	object_ids  =Objectresponsible.where(:package_id => package_ids).pluck(:id)
    	   else
    	   	object_ids  =Objectresponsible.where(:package_id =>package_ids,:id=>object_ids).pluck(:id)
    	   end
            @outher = 1
    	end

    	# search components 
    	if params[:sSearch_3].present?
    	   component_ids = Component.where("applicationcomponent like :search" ,search: "%#{params[:sSearch_3]}%").pluck(:id)
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
            @outher = 1
    	end
    	
        #search sapname
    	if params[:sSearch_9].present?
    		person_ids = Person.where("firstname like :search or lastname like :search or sapname like :search",search: "%#{params[:sSearch_9]}%").pluck(:id)
    		if object_ids.empty?
    			object_ids = Objectresponsible.where(:person_id => person_ids).pluck(:id)
    		else
    			object_ids = Objectresponsible.where(:person_id => person_ids,:id=>object_ids).pluck(:id)
    		end
            @outher = 1
    	end
        if params[:sSearch_10].present?
            case params[:sSearch_10]
            when "YES" then
             person_ids = Person.where(:ims=>"YES").pluck(:id)
             if object_ids.empty?
                object_ids = Objectresponsible.where(:person_id => person_ids).pluck(:id)
            else
                object_ids = Objectresponsible.where(:person_id => person_ids,:id=>object_ids).pluck(:id)
            end
            @outher = 1
            when "NO" then
                 person_ids = Person.where(:ims=>"NO").pluck(:id)
                 if object_ids.empty?
                    object_ids = Objectresponsible.where(:person_id => person_ids).pluck(:id)
                else
                    object_ids = Objectresponsible.where(:person_id => person_ids,:id=>object_ids).pluck(:id)
                end
                @outher = 1
            end
        end
    	if @outher==1
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
	    return checkmen
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    if params[:iDisplayLength].to_i > 0
        params[:iDisplayLength].to_i
    else
        10000000
    end
    

  end

  def sort_column
    columns = %w[objectresponsible_id feedback release component package objectresponsible_id priority checkid messageid objectresponsible_id ims prodrel]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end