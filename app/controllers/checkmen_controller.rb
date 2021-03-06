require 'csv'
class CheckmenController < ApplicationController
  # GET /checkmen
  # GET /checkmen.json
  def index

      # if params[:select].nil?
          @checkman = Checkman.where("status='open'")
      # else
      #     filter = params[:select]
      #     content = params[:content]
      #     case filter
      #     when "prodrel" then 
      #       if params[:content] =="ture"
      #         @checkman = Checkman.where("prodrel = ? ",true)
      #       else
      #         @checkman = Checkman.where("prodrel = ? ",false)
      #       end
      #     when "person" then
      #       @person = Person.find_by_sapname(content)
      #       @objectresponsible = @person.objectresponsibles
      #     end
      #  end

     
     respond_to do |format|
      format.html
      format.json {render json:CheckmenDatatable.new(view_context, @checkman)}
      # format.xls { send_data}
     end
  end

  # GET /checkmen/1
  # GET /checkmen/1.json
  def show
    @checkman = Checkman.find(params[:id])

    respond_to do |format|
      format.html # show.html.erbg
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
    if request.post?
      #initialize release ,importnumber 
      temp_release = params[:release]
      isp = params[:isprodrel]
      n,m = 0,0
      #check file1
        if params[:file1]&&params[:release]!="NULL"&&params[:isprodrel]!="NULL"
          @result = Checkman.upload_to_database(params[:file1],temp_release,isp)
          @checkman = Checkman.where("status = 'open' and release =?",temp_release)
          respond_to do |format|
            format.html
            format.json {render json: CheckmenDatatable.new(view_context,@checkman)}
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
    end  
  end

  def item_detail
    @checkman = Checkman.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def search
     index
     render index
  end
  
  def mail_multiple 
  if !params[:checkman_ids].blank?
  @email_templates = EmailTemplate.all
  @checkman_ids = params[:checkman_ids]
  @checkman = Checkman.find(params[:checkman_ids]) 
  @respeople = Array.new
  n = 0
  @checkman.each do |c|
      if c.objectresponsible.person_id.present?
      @respeople[n] = c.objectresponsible.person.sapname  
    end
      n = n+1 
  end

  @respeople = @respeople.uniq
  if params[:commit] == "Export EXCEL"
    # Spreadsheet.client_encoding = 'UTF-8'
    #       book = Spreadsheet::Workbook.new
    #       sheet1 = book.create_worksheet :name=>'checkman_errors'
    #       sheet1.row(0).concat %w{System Priority Prodrel Check(Check_id) Checkmessage(message_id) Objectname Package Application_Component Responsible}
    #       count_row = 1
    #       @checkman.each do |c|
    #         sheet1[count_row,0] = c.release
    #         sheet1[count_row,1] = c.priority 
    #         sheet1[count_row,2] = c.prodrel
    #         sheet1[count_row,3] = c.checkid
    #         sheet1[count_row,4] = c.messageid
    #         sheet1[count_row,5] = c.objectresponsible.objectname
    #         sheet1[count_row,6] = c.objectresponsible.package.package
    #         sheet1[count_row,7] = c.objectresponsible.package.component.applicationcomponent
    #         sheet1[count_row,8] = c.objectresponsible.person.sapname
    #         count_row += 1
    #      end
    #       e_format = Spreadsheet::Format.new :color => :blue,
    #                                :size => 11,
    #                                :pattern_fg_color =>:red
    #       sheet1.row(0).default_format = e_format
    #      filepath = "checkman_error_"+@checkman.first.release+"_"+@checkman.first.ncount.to_s+"_"+@checkman.count.to_s+"_"+Time.now.strftime('%H%M%S')+".xls"  
    #      book.write filepath
    #      @cu_filepath = File.expand_path(filepath)
    #      # response.headers['X-Accel-Redirect'] = "/"+filepath
    #      send_file(filepath,:disposition=>'inline' )
         render :js=>"alert('There is still something wrong~~~');"
         # render :nothing => true
  end

  if params[:commit] == "Send to each Responsible"
    @respeople.each do |r|
      current_person = Person.find_by_sapname(r)
      current_checkman = Array.new
    @checkman.each do |cu|
      if cu.objectresponsible.person.sapname == r
          current_checkman<< cu
      end
    end
       @c_mail_address = current_person.email
       @c_mail_subject = "[Action] Open production relevant CHECKMAN messages in" + current_checkman.first.release
       @c_mail_content = "Hi #{current_person.sapname},\n\nERP EHP7 ends ,please process remaing production-relevant CHECKMAN messages for ,as these would otherwise hinder task-based production for component validation to start:\n\nLAST Version Anthor is you.\n\nHints for processing:\n .Result in the attachment are from system #{current_checkman.first.release}\nIn case you need an exception,please create this using approver = SCHMIAUKE!\n\nMany Thanks & Regards"
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
            sheet1[count_row,8] = c.objectresponsible.person.sapname
            count_row += 1
         end
          e_format = Spreadsheet::Format.new :color => :blue,
                                   :size => 11,
                                   :pattern_fg_color =>:red
          sheet1.row(0).default_format = e_format
         filepath = r+"_checkman_error_"+current_checkman.first.release+"_"+current_checkman.first.ncount.to_s+"_"+current_checkman.count.to_s+Time.now.strftime('%H%M%S')+".xls"
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
    respond_to do |format|
      format.js
    end
 end
  if params[:commit] == "Send Email"
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
            sheet1[count_row,7] = c.objectresponsible.package.component.applicationcomponent unless c.objectresponsible.package.component_id.blank?
            sheet1[count_row,8] = c.objectresponsible.person.sapname  unless c.objectresponsible.person_id.blank?
            count_row += 1
         end
          e_format = Spreadsheet::Format.new :color => :blue,
                                   :size => 11,
                                   :pattern_fg_color =>:red
          sheet1.row(0).default_format = e_format
         filepath = "checkman_error_"+@checkman.first.release+"_"+@checkman.first.ncount.to_s+"_"+@checkman.count.to_s+"_"+Time.now.strftime('%H%M%S')+".xls"  
         book.write filepath
         @cu_filepath = File.expand_path(filepath)
    @person = Person.find_all_by_sapname(@respeople)
    # @c_mail_content  = "Hi ,\n\nERP EHP7 ends ,please process remaing production-relevant CHECKMAN messages for #{@checkman.first.objectresponsible.package.component.applicationcomponent},as these would otherwise hinder task-based production for component validation to start:\n\nLAST Version Anthor is you.\n\nHints for processing:\n .Result in the attachment are from system #{@checkman.first.release}\nIn case you need an exception,please create this using approver = SCHMIAUKE!\n\nMany Thanks & Regards"
    m = 0
    @person.each do |p|
      if m ==0||p.email.present?
        @c_mail_address = p.email
      else
        if p.email 
        @c_mail_address << "\;"+ p.email
        end
      end
      m = m+1
    end
    @send_type = 1 
    respond_to do |format|
      format.js
    end
  end

  else 
    render  :js =>"alert('There is no selected message !Please select..');"
  end
  end

  def send_multiple
    @mail_address = params[:T_mail_address].split(";")
    @mail_cc_address = params[:T_mail_cc_address].split(";") unless params[:T_mail_cc_address].blank?
    @filepath = params[:filepath]
    @ids = params[:ids].split("\"")
    length = @ids.length
    @checkman = Checkman.find(@ids[1].to_i)
    @mail_content = params[:T_mail_content].gsub(/#system#/,@checkman.release).gsub(/#package#/, @checkman.objectresponsible.package.package)
    if @checkman.objectresponsible.person_id.present?
    @mail_content = @mail_content.gsub(/#name#/,@checkman.objectresponsible.person.firstname+" "+@checkman.objectresponsible.person.lastname)
    end
    if @checkman.objectresponsible.package.component_id.present?
     @mail_content = @mail_content.gsub(/#component#/,@checkman.objectresponsible.package.component.applicationcomponent)
    end
    WIN32OLE.ole_initialize
          outlook = WIN32OLE.new('Outlook.Application')  
          message = outlook.CreateItem(0)  
          message.Subject = params[:T_mail_subject]
          message.Body = @mail_content
           message.To = @mail_address[0]
          # @mail_address.each do |address|
          #   message.Recipients.Add address
          # end
          if !@mail_cc_address.nil?
            message.Cc = @mail_cc_address[0]
          end
          message.Attachments.Add(@filepath, 1)
          message.Send
     @check_ids = Array.new()
     i=1
     while i<length
      checkman = Checkman.find(@ids[i])
      checkman.feedback = "Addressed"
      checkman.save
      @check_ids << @ids[i]
      i = i+2
     end
     respond_to do |format|
      format.js
     end
  end

  def person_edit
    @checkman = Checkman.find(params[:id])
    @object = @checkman.objectresponsible
    if @object.person_id
      @person = @object.person
    else
      @person = Person.new
    end
    # if @object.package.component_id.nil?
    #    @component = ""
    #  else
    #    @component = @object.package.component.applicationcomponent
    #  end
    respond_to do |format|
      format.js
    end
  end

  def update_person_edit
    @checkmanid= params[:checkmanid]
    @object = Objectresponsible.find(params[:id])
    @package = @object.package
    # if params[:component].present?
    #   @component = Component.where(:applicationcomponent=>params[:component])
    #   if !@component.empty?
    #     @package.component_id = @component[0].id
    #   else
    #     @component=Component.create(
    #       :applicationcomponent => params[:component]
    #       )
    #     @package.component_id = @component.id
    #   end
    #     @package.save
    # end
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
      end
        if params[:orgunit].present?
            @person.orgunit =params[:orgunit]
            @person.ims = params[:orgunit].rindex("IMS").present?? "YES":"NO"
        end
        @person.save
      @object.person_id = @person.id
    else
     render :js=>"alert('SAP Name Cannot blank');"
    end
    @object.save
  end
  respond_to do |format|
    format.js
  end
end