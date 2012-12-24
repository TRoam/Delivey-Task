class ComponentsController < ApplicationController
  def index
    @components = Component.all
    @component  = Component.new
    @number = @components.count
    flash[:notice] = "Hi,there are #{@number} components."
    respond_to do |format|
      format.html 
      format.js
    end
  end
  def edit
    @component = Component.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def update
    @component = Component.find(params[:id])

    respond_to do |format|
      if @component.update_attributes(params[:component])
        format.html { redirect_to @component, notice: 'Product was successfully updated.' }
        format.js
      else
        format.html { render action: "edit" }
        format.js { render js: @component.errors, status: :unprocessable_entity }
      end
    end
  end
   def show
    @component = Component.find(params[:id])

     respond_to do |format|
      format.html # show.html.erb
      format.js
     end
    end
    def detail
      @component = Component.find(params[:id])
      @checkman = @component.checkmen.find_all_by_status("open")
      @count = @checkman.count
      if @count == 0 
         respond_to do |format|
          format.html{flash[:notice] = "congratulations!There is no checkman errors in the component!"}
          format.js 
         end
      else
        respond_to do |format|
          format.html{flash[:notice] = "In the package :  #{@component.package},there are #{@count} still open records!"}
          format.js 
        end
      end
    end
    
    def new
      @component = Component.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
    end
    
    def create
       @component = Component.new(params[:component])

    respond_to do |format|
      if @component.save
        flash[:notice] = "Component Successful create!"
        format.js 
      else
        format.html { render action: "new" }
        format.js 
      end
    end
    end
    
    def import      
    end

    def upload
      #nil?
      if request.post? && params[:file]
        nowtime = Time.new
        n ,@number= 0
        file = params[:file]
        CSV.parse(file) do |row|
          n +=1
          #SKIP:header first or blank row
          next if n==1 or row.join.blank? 
          component =Component.find_by_package(row[0])       
          if !component
            component.create(
                            :package => row[0],
                            :softwarecomponent =>row[1],
                            :applicationcomponent => row[2],
                            :changeperson => row[3]
                            )
          else
            component.softwarecomponent = row[1]
            component.applicationcomponent = row[2]
            component.changeperson = row[3]
            component.save
          end

          @number += 1
        end
        flash[:notice] = "Import Successful! #{@number} records saved"
        @component = Component.find(1)      
      else
        flash[:notice] = "Please select a file and import!"
        redirect_to :action=>:import
      end
    #rescue => exception 
    # If an exception is thrown, the transaction rolls back and we end up in this rescue bloc
    # get the error and HTML escape it 
    #   flash[:notice] = "There are some errors during import,please try again!"
    #  redirect_to :action =>:impot
    end
end