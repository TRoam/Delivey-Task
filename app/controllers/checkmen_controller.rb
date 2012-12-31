require 'csv'
# require 'upload_job'
# require 'checkmen_helper'

class CheckmenController < ApplicationController
  # GET /checkmen
  # GET /checkmen.json
  def index

     #@q = Checkman.search(params[:q])
     # @checkman = params[:distinct].to_i.zero? ? @q.result : @q.result(distinct: true)
     @q=Checkman.search(params[:q])
       if params[:q].nil?
         @checkman =Checkman.limit(100).find_all_by_status("open")
       else
          @checkman = @q.result
          
       end
     @number = @checkman.count
     flash[:notice] = "There are #{@number} records!"
     @q.build_condition if @q.conditions.empty?
     @q.build_sort if @q.sorts.empty?   
     # respond_to do |format|
     #    format.js
     # end
  end

  # GET /checkmen/1
  # GET /checkmen/1.json
  def show
    @checkman = Checkman.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @checkman }
    end
  end

  # GET /checkmen/1/edit
  def edit
    @checkman = Checkman.find(params[:id])
    @comment =@checkman.comments

    respond_to do |format|
      format.html
      format.js
    end
  end
  # PUT /checkmen/1
  # PUT /checkmen/1.json
  def update
    @checkman = Checkman.find(params[:id]) 
    comment = Comment.create(
           :content => params[:checkman][:comments][:content],
           :checkman_id =>params[:id]
      )
    @checkman.feedback = params[:checkman][:feedback]
    @comment = @checkman.comments.last
    respond_to do |format|
      if @checkman.save
        format.html { redirect_to "/checkmen", notice: 'Checkman was successfully updated.' }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end
  # DELETE /checkmen/1
  # DELETE /checkmen/1.json
  def destroy
    @checkman = Checkman.find(params[:id])
    @checkman.destroy

    respond_to do |format|
      format.html { redirect_to checkmen_url }
      format.json { head :no_content }
    end
  end
  def import
    # render :layout =>false
  end

  # import new data
  def upload
    @uploadall = Array.new
    @uploadrel = Array.new
    if request.post?
      #initialize release ,importnumber 
      temp_release = params[:release]
      n , m = 0,0
            #check file1
        if params[:file1]&&params[:release]!="NULL"&&params[:isprodrel]!="NULL"
          @result = Checkman.upload_to_database(params[:file1],temp_release,params[:isprodrel])
          @checkman= Checkman.find_all_by_status("open")
          respond_to do |format|
            format.html
          end
          else
            if !params[:file1]
              render :js =>"alert('Oops!Please chose one file!');" 
            else
              if params[:isprodrel] == "NULL"
                render :js=>"alert('Oops!Please select if it Prod.rel!');"
              else
                render :js=>"alert('Oops!Please select a System!');"
              end
            end
          end
       
        #this file is prodrel ,set prodrel true
        #get the path of import file
        # infile1 = params[:upload][:file1].read
        # linenumber1 = 0
        # #import file 
        # CSV.parse(infile1) do |row|
        #   n += 1
        #   #SKIP: header first or blank row
        #   next if n==1 or row.join.blank?
        #     row[1..7].each do |str|
        #       unless Encoding.compatible?(str,1.to_s)
        #         str = str.encode("UTF-8",undef: :replace)
        #       end
        #     end
        #   @uploadrel[linenumber1] = row
        #   linenumber1 +=1
        # end
     
      #check and import file2
      # if params[:file2]
        # Checkman.upload_to_database(params[:file2],temp_release,0)
        # #save release ,prodrel
        # #this file is prodrel ,set prodrel false
        # #get the path of import file
        # # infile2 = params[:upload][:file2].read
        # # linenumber2 = 0
        # # #import file 
        # # CSV.parse(infile2) do |row|
        # #   m += 1
        # #   #SKIP: header first or blank row
        # #   next if m==1 or row.join.blank?
        # #   row[1..7].each do |str|
        # #       unless Encoding.compatible?(str,1.to_s)
        # #         str = str.encode("UTF-8",undef: :replace)
        # #       end
        # #     end
        # #   @uploadall[linenumber2] = row
        # #   linenumber2 += 1 
        # # end
      # end
     #  @importnumber = @uploadall.length + @uploadrel.length
     # flash[:notice] = "Import successful !, #{@importnumber} ,records are imported.Data are saving..."
     # Delayed::Job.enqueue(UploadJob.new(@uploadall,@uploadrel,temp_release))
    end    
    # Checkman.upload_to_database(@uploadall,@uploadrel,temp_release)
  end

  def item_detail
    @checkman = Checkman.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def search
    index  
    render :index
  end
  
  def mail_multiple 
  if !params[:checkman_ids].blank?
  @checkman_ids = params[:checkman_ids]
  @checkman = Checkman.find(params[:checkman_ids]) 
  @respeople = Array.new
  n = 0
  @checkman.each do |c|
      @respeople[n] = c.objectresponsible.person.responsibleperson
      n = n+1 
  end

  @respeople = @respeople.uniq
  
  if params[:commit]!="Send Email"
    @respeople.each do |r|
      current_person = Person.find_by_responsibleperson(r)
      current_checkman = Array.new
    @checkman.each do |cu|
      if cu.objectresponsible.person.responsibleperson == r
          current_checkman<< cu
      end
    end
       @c_mail_address = current_person.email
       @c_mail_subject = "[Action] Open production relevant CHECKMAN messages in" + current_checkman.first.release
       @c_mail_content = "Hi #{current_person.responsibleperson},\n\nERP EHP7 ends ,please process remaing production-relevant CHECKMAN messages for ,as these would otherwise hinder task-based production for component validation to start:\n\nLAST Version Anthor is you.\n\nHints for processing:\n .Result in the attachment are from system #{current_checkman.first.release}\nIn case you need an exception,please create this using approver = SCHMIAUKE!\n\nMany Thanks & Regards"
    Spreadsheet.client_encoding = 'UTF-8'
          book = Spreadsheet::Workbook.new
          sheet1 = book.create_worksheet :name=>'checkman_errors'
          sheet1.row(0).concat %w{System Priority Prodrel Check(Check_id) Checkmessage(message_id) Objectname Package Application_Component }
          count_row = 1
          current_checkman.each do |c|
            sheet1[count_row,0] = c.release
            sheet1[count_row,1] = c.priority 
            sheet1[count_row,2] = c.prodrel
            sheet1[count_row,3] = c.checkid
            sheet1[count_row,4] = c.messageid
            sheet1[count_row,5] = c.objectresponsible.objectname
            sheet1[count_row,6] = c.objectresponsible.package.package 
            sheet1[count_row,7] = c.objectresponsible.package.component.applicationcomponent
            sheet1[count_row,8] = c.objectresponsible.person.responsibleperson
            count_row += 1
         end
          e_format = Spreadsheet::Format.new :color => :blue,
                                   :size => 11,
                                   :pattern_fg_color =>:red
          sheet1.row(0).default_format = e_format
         filepath = r+"_checkman_error_"+current_checkman.first.release+"_"+current_checkman.first.ncount.to_s+"_"+current_checkman.count.to_s+".xls"
         book.write filepath
         cu_filepath = File.expand_path(filepath)
          WIN32OLE.ole_initialize
          outlook = WIN32OLE.new('Outlook.Application')  
          message = outlook.CreateItem(0)  
          message.Subject = @c_mail_subject
          message.Body = @c_mail_content
          message.To = @c_mail_address
          message.Attachments.Add(cu_filepath, 1)  
          message.Send 
          current_checkman.each do |c|
            c.feedback = "Addressed"
            c.save
          end
   end
   @send_type = 0
  else
    Spreadsheet.client_encoding = 'UTF-8'
          book = Spreadsheet::Workbook.new
          sheet1 = book.create_worksheet :name=>'checkman_errors'
          sheet1.row(0).concat %w{System Priority Prodrel Check(Check_id) Checkmessage(message_id) Objectname Package Application_Component Responsible}
          count_row = 1
          @checkman.each do |c|
            sheet1[count_row,0] = c.release
            sheet1[count_row,1] = c.priority 
            sheet1[count_row,2] = c.prodrel
            sheet1[count_row,3] = c.checkid
            sheet1[count_row,4] = c.messageid
            sheet1[count_row,5] = c.objectresponsible.objectname
            sheet1[count_row,6] = c.objectresponsible.package.package
            sheet1[count_row,7] = c.objectresponsible.package.component.applicationcomponent
            sheet1[count_row,8] = c.objectresponsible.person.responsibleperson
            count_row += 1
         end
          e_format = Spreadsheet::Format.new :color => :blue,
                                   :size => 11,
                                   :pattern_fg_color =>:red
          sheet1.row(0).default_format = e_format
         filepath = "checkman_error_"+@checkman.first.release+"_"+@checkman.first.ncount.to_s+"_"+@checkman.count.to_s+".xls"  
         book.write filepath
         @cu_filepath = File.expand_path(filepath)
    @person = Person.find_all_by_responsibleperson(@respeople)
    @c_mail_content  = "Hi ,\n\nERP EHP7 ends ,please process remaing production-relevant CHECKMAN messages for #{@checkman.first.objectresponsible.package.component.applicationcomponent},as these would otherwise hinder task-based production for component validation to start:\n\nLAST Version Anthor is you.\n\nHints for processing:\n .Result in the attachment are from system #{@checkman.first.release}\nIn case you need an exception,please create this using approver = SCHMIAUKE!\n\nMany Thanks & Regards"
    m = 0
    @person.each do |p|
      if m ==0
        @c_mail_address = p.email
      else
        if p.email 
        @c_mail_address << "\;"+ p.email
        end
      end
      m = m+1
    end
    @send_type = 1 
  end
    respond_to do |format|
      format.js
    end
  else 
    render  :js =>"alert('Oops!There is no selected message !Please select..');"
  end
  end

  def send_multiple
    @mail_address = params[:T_mail_address].split(";")
    @mail_cc_address = params[:T_mail_cc_address].split(";") unless params[:T_mail_cc_address].blank?
    @filepath = params[:filepath]
    WIN32OLE.ole_initialize
          outlook = WIN32OLE.new('Outlook.Application')  
          message = outlook.CreateItem(0)  
          message.Subject = params[:T_mail_subject]
          message.Body = params[:T_mail_content]
          message.To = @mail_address[0]
          @mail_address.each do |address|
            message.Recipients.Add address
          end
          if !@mail_cc_address.nil?
            message.Cc = @c_mail_cc_address[0]
          end
          message.Attachments.Add(@filepath, 1)  
          message.Send
       respond_to do |format|
        format.js
       end
  end

end