class PackagesController < ApplicationController
  def index
  	@package = Package.all
  end

  def custom
      
      @package = Package.find_all_by_component_id(nil)
      if @package.count == 0
      	@component = Array.new
      	flash[:notice] = "Nothing to do ......All the package have be assigned"
      else
      	@component = Component.all
      	flash[:notice]  = "Please choose packages leftside "
      end
    end

def package_to_component
    if params[:component]&&params[:checkman_ids]
    	 component_id = params[:component]
      @package_ids = params[:checkman_ids]
      @package =Package.find(params[:checkman_ids])
      @package.each do |p|
        p.component_id = component_id
        p.save
      end
      @result = 0
    else
    	if !params[:component]
    		@result = 1
    	else
    		@result = 2
    	end
    end
      respond_to do |format|
        format.js
      end
    end

    def package_edit
      @package =  Package.find(params[:id])
      if @package.person_id.present?
         @person= Person.finde(@package.person_id)
       else
         @person = Person.new()
      end
      respond_to do |format|
        format.js
      end
    end

    def update_package_edit
      @package = Package.find(params[:id])
      if params[:sapname].present?
      @person = Person.where(:sapname => params[:sapname])
          if @person.empty?
            @person = Person.create(
                      :sapname =>params[:sapname],
                      :firstname =>params[:firstname],
                      :lastname =>params[:lastname],
                      :eid =>params[:eid],
                      :email=>params[:email],
                      :orgunit => params[:orgunit]
              )
          else
            @person = @person[0]
            @person.firstname =params[:firstname]  unless params[:firstname].nil?
            @person.lastname  =params[:lastname]   unless params[:lastname].nil?
            @person.eid       =params[:eid]        unless params[:eid].nil?
            @person.email     =params[:email]      unless params[:email].nil?
            if params[:orgunit].present?
              @person.orgunit =params[:orgunit]
              @person.ims = params[:orgunit].rindex("IMS").present?? "YES":"NO"
            end
            @person.save
          end
      @package.person_id = @person.id
      @package.save
    else
     render :js=>"alert('SAP Name Cannot blank');"
    end
  respond_to do |format|
    format.js
  end
    end
end
