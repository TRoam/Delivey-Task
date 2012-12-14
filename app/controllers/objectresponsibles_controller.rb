class ObjectresponsiblesController < ApplicationController
  def index
    @object = Objectresponsible.all
    @number = @object.count
    flash[:notice] ="Hi ,there are #{@number} objects!"
  end
  def edit
     
    @object = Objectresponsible.find(params[:id])
  end
  
  def update
    @object = Objectresponsible.find(params[:id])
    @person = Person.find_by_responsibleperson(params[:objectresponsible][:contact])
    if !@person
      @person = Person.create(
              :responsibleperson =>params[:objectresponsible][:contact]                
        )
    end
    @object.person_id  = @person.id
    respond_to do |format|
      if @object.save
        format.html { redirect_to @object, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end
   def show
    @object = Objectresponsible.find(params[:id])
    
     respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @object }
     end
    end
    def detail
      @object = Objectresponsible.find(params[:id])
      @checkman = @object.checkmen.find_all_by_status("open")
      @count = @checkman.count
      if @count == 0 
      flash[:notice] = "congratulations!There is no checkman errors in the object!"
      else
        flash[:notice] ="In the object :  #{@object.objectname},there are #{@count} still open records!"
      end
    end
    def new
      @object = Objectresponsible.new
      @package = Component.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @object }
      format.js
    end
    end
    
    def create
       
       @object = Objectresponsible.new(
                              :objectname   => params[:objectresponsible][:objectname],
                              :contact      => params[:objectresponsible][:contact],
                              :objecttype   => params[:objectresponsible][:objecttype],
                              :component_id => params[:objectresponsible][:component][:package]
                                     )
         person = Person.find_by_responsibleperson(params[:objectresponsible][:person])
         if !person
           person = Person.create(
                        :responsibleperson => params[:objectresponsible][:person]
                                  )    
         end
         @object.person_id = person.id
     respond_to do |format|
      if @object.save
        format.html { redirect_to @object, notice: 'Product was successfully created.' }
        format.json { render json: @object, status: :created, location: @object }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @object.errors, status: :unprocessable_entity }
        format.js
      end
    end
    end
end
