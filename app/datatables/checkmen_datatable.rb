class CheckmenDatatable
	delegate :params,:h,:link_to, :number_to_current, :check_box_tag,to: :@view

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
				link_to(:action =>'edit',:id=>c.id,:remote=>true) do
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
				h(c.objectresponsible.person.responsibleperson),	
				if c.prodrel?
					h("True")
				else
					h("False")
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
    if params[:sSearch].present?
      package = Package.where("package like :search " , search: "%#{params[:sSearch]}%")
      # checkmen = package.objectresponsibles.checkmen.find_all_by_status("open")
      checkmen = checkmen.where("checkid like :search or messageid like :search or release like :search or status like :search or dlm like :search or feedback like :search or prodrel like :search", search: "%#{params[:sSearch]}%")
    end
    checkmen
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
     10
  end

  def sort_column
    columns = %w[checkid messageid ]
    columns[params[:iSortCol_3].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end