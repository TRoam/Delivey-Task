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
end
