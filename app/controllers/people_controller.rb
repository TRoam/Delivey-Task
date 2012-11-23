class PeopleController < ApplicationController
  def index
    @page_title = "Person"
    @person = Person.all
  end
  def edit
    @person = Person.find(params[:id])
  end
  
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end
   def show
    @person = Person.find(params[:id])

     respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @perosn }
     end
    end
    def detail
      @page_title = "Detail"
      @person = Person.find(params[:id])
      @checkman = @person.checkmen.find_all_by_status("open")
      @count = @checkman.count
      @url_t = "http://10.59.154.73/people/#{@person.id}/detail"
      if @count == 0 
      flash[:notice] = "congratulations!There is no checkman errors in the component!"
      else
        flash[:notice] ="There are #{@count} still open records responsibled by #{@person.responsibleperson}!"
      end
    end
    
    def sendmail
      @person = Person.find(params[:id])
      CheckmanMailer.delay.checkman_error_email(@person)
      Flash[:notice] = "Send Emails Successful !"
    end
end
