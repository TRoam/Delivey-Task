class CheckmenDatatable
	delegate :params,:h,:link_to, :number_to_current, to: :@view

	def initialize(view)
		@view = view
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

				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove"),
				h("icon-remove")

			]
		end
	end

	def checkmen
      @checkmen ||= fetch_checkmen
    end

  def fetch_checkmen
    checkmen = Checkman.order("#{sort_column} #{sort_direction}")
    checkmen = checkmen.page(page).per_page(per_page)
    if params[:sSearch].present?
      checkmen = checkmen.where("checkid like :search ", search: "%#{params[:sSearch]}%")
    end
    checkmen
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[checkid messageid]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end