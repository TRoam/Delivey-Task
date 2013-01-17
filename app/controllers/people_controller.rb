require 'rubygems'
require 'win32ole'
require 'spreadsheet'
class PeopleController < ApplicationController
  
  def index
    # @page_title = "Person"
    @person = Person.all
    @number = @person.count
    flash[:notice] = "Hi ,there are #{@number} active person !"
  end
  def edit
    @person = Person.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
        format.js
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
         flash[:notice] ="There are #{@count} still open records responsibled by #{@person.sapname}!"
      end
    end
    
    def sendmail
      @person = Person.find(params[:id])
      CheckmanMailer.checkman_error_email(@person).deliver
    end

    def manual_mail
      @person = Person.find(params[:id])
      @checkman = @person.checkmen.find_all_by_status("open")
      if request.post?
        @c_mail_address    = params[:T_mail_address]
        @c_mail_cc_address = params[:T_mail_cc_address]
        @c_mail_subject    = params[:T_mail_subject]
        @c_mail_content    = params[:T_mail_content]
      else
       @c_mail_address = @person.email
       @c_mail_subject = "[Action] Open production relevant CHECKMAN messages in" + @checkman.first.release
       @c_mail_content = "Hi #{@person.sapname},\n\nERP EHP7 ends ,please process remaing production-relevant CHECKMAN messages for #{@checkman.first.objectresponsible.component.applicationcomponent},as these would otherwise hinder task-based production for component validation to start:\n\nLAST Version Anthor is you.\n\nHints for processing:\n .Result in the attachment are from system #{@checkman.first.release}\nIn case you need an exception,please create this using approver = SCHMIAUKE!\n\nMany Thanks & Regards"
       
      end
      if !@c_mail_address.nil? && !@c_mail_subject.nil?
      Spreadsheet.client_encoding = 'UTF-8'
          book = Spreadsheet::Workbook.new
          sheet1 = book.create_worksheet :name=>'checkman_errors'
          sheet1.row(0).concat %w{System Priority Prodrel Check(Check_id) Checkmessage(message_id) Objectname Package Application_Component }
          count_row = 1
          @checkman.each do |c|
            sheet1[count_row,0] = c.release
            sheet1[count_row,1] = c.priority 
            sheet1[count_row,2] = c.prodrel
            sheet1[count_row,3] = c.checkid
            sheet1[count_row,4] = c.messageid
            sheet1[count_row,5] = c.objectresponsible.objectname
            sheet1[count_row,6] = c.objectresponsible.component.package 
            sheet1[count_row,7] = c.objectresponsible.component.applicationcomponent
            count_row += 1
         end
          e_format = Spreadsheet::Format.new :color => :blue,
                                   :size => 11,
                                   :pattern_fg_color =>:red
          sheet1.row(0).default_format = e_format
         @filepath = @person.sapname+"_checkman_error_"+@checkman.first.release+"_"+@checkman.first.ncount.to_s+"_"+@checkman.count.to_s+".xls"
         book.write @filepath
         filepath = File.expand_path(@filepath)
          WIN32OLE.ole_initialize
          outlook = WIN32OLE.new('Outlook.Application')  
          message = outlook.CreateItem(0)  
          message.Subject = @c_mail_subject
          message.Body = @c_mail_content
          message.To = @c_mail_address
          if !@c_mail_cc_address.nil?&&request.post?
            message.Cc = @c_mail_cc_address
          end
          message.Attachments.Add(filepath, 1)  
          message.Send 
          @checkman.each do |c|
            if c.comments.empty?
              comment = Comment.create( 
                  :feedback => "addressed",
                  :checkman_id => c.id
                )
            end
            c.comments.last.feedback = "addressed"
            c.comments.last.save
          end
          @message = "Mila Send Successfully, you can  also check it in your outlook "
          @result = 1
        else
          @message = "Sorry ,but the email address or subject is Null ,Please fill and try again !"
          @result = 2
        end
        if request.post?
          flash[:notice] ="Mila Send Successfully, you can  also check it in your outlook "
          render :detail 
        else
          respond_to do |format|
          format.js
          end
        end
    end

    def email_format
      @person = Person.find(params[:id])
      @checkman = @person.checkmen.find_all_by_status("open")
      @c_mail_content  = "Hi #{@person.sapname},\n\nERP EHP7 ends ,please process remaing production-relevant CHECKMAN messages for #{@checkman.first.objectresponsible.component.applicationcomponent},as these would otherwise hinder task-based production for component validation to start:\n\nLAST Version Anthor is you.\n\nHints for processing:\n .Result in the attachment are from system #{@checkman.first.release}\nIn case you need an exception,please create this using approver = SCHMIAUKE!\n\nMany Thanks & Regards"

      respond_to do |format|
        format.js
      end
    end

    def mail_content_type_prodrel
      @person = Person.find(params[:id])
      respond_to do |format|
        format.js
      end
    end

    def mail_content_type_all
      @person = Person.find(params[:id])
      respond_to do |format|
        format.js
      end
    end
end

