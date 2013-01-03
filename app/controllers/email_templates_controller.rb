class EmailTemplatesController < ApplicationController
 
  def index
  	@email_templates = EmailTemplate.all
    @email_template = EmailTemplate.new()
  end

  def show
 	  @email_template = EmailTemplate.find(params[:id])
    respond_to do |format|
      format.js
    end 
  end

  def edit
    @email_template = EmailTemplate.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

   def update
      @email_template = EmailTemplate.find(params[:id])
      
      respond_to do |format|
      if @email_template.update_attributes(params[:email_template])
        format.js
      else
        format.js { render js: @email_template.errors, status: :unprocessable_entity }
      end
    end

   end
  def new
      @email_template = EmailTemplate.new()
  end

  def create
    @email_template = EmailTemplate.new(params[:email_template])
    respond_to do |format|
    if @email_template.save
      @result = 1
    else
      @result = 0
    end
    format.js
   end
  end
end