class ObjectresponsiblesController < ApplicationController
  def index
    @page_title = "Object"
    @object = Objectresponsible.all
  end
  def edit
     @page_title = "Object"
    @object = Objectresponsible.find(params[:id])
  end
  
  def update
     @page_title = "Object"
    @object = Objectresponsible.find(params[:id])

    respond_to do |format|
      if @object.person.update_attributes( :responsibleperson =>params[:objectresponsible][:contact])
        format.html { redirect_to @object, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @object.errors, status: :unprocessable_entity }
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
    end
    end
    
    def create
       @page_title = "Object"
       @object = Objectresponsible.new(
                           :objectname   => params[:objectname],
                           :contact      => params[:contact],
                           :objecttype   => params[:objecttype],
                           :component_id => params[:package]
                                     )
         person = Person.find_by_responsibleperson(params[:person])
         if !person
           person = Person.create(
                        :responsibleperson => params[:person]
                                  )    
         end
         @object.person_id = person.id
     respond_to do |format|
      if @object.save
        format.html { redirect_to @object, notice: 'Product was successfully created.' }
        format.json { render json: @object, status: :created, location: @object }
      else
        format.html { render action: "new" }
        format.json { render json: @object.errors, status: :unprocessable_entity }
      end
    end
    end
end
