require 'csv'
# require 'upload_job'
# require 'checkmen_helper'

class CheckmenController < ApplicationController
  # GET /checkmen
  # GET /checkmen.json
  def index

     #@q = Checkman.search(params[:q])
     # @checkman = params[:distinct].to_i.zero? ? @q.result : @q.result(distinct: true)
     @q=Objectresponsible.search(params[:q])
       if params[:q].nil?
         @checkman =Checkman.find_all_by_status("open")
       else
          @objectresponsible = @q.result
          @checkman = Array.new()
          @objectresponsible.each do |o|
            @checkman = @checkman + o.checkmen.all
          end
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
           :checkman_id =>params[:id],
           :feedback => params[:checkman][:comments][:feedback]
      )
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
      temp_release = params[:upload][:release]
      n , m = 0,0
            #check file1
      if params[:upload][:file1]
        #this file is prodrel ,set prodrel true
        #get the path of import file
        infile1 = params[:upload][:file1].read
        linenumber1 = 0
        #import file 
        CSV.parse(infile1) do |row|
          n += 1
          #SKIP: header first or blank row
          next if n==1 or row.join.blank?
            row[1..7].each do |str|
              unless Encoding.compatible?(str,1.to_s)
                str = str.encode("UTF-8",undef: :replace)
              end
            end
          @uploadrel[linenumber1] = row
          linenumber1 +=1
        end
      end
      #check and import file2
      if params[:upload][:file2]
        #save release ,prodrel
        #this file is prodrel ,set prodrel false
        #get the path of import file
        infile2 = params[:upload][:file2].read
        linenumber2 = 0
        #import file 
        CSV.parse(infile2) do |row|
          m += 1
          #SKIP: header first or blank row
          next if m==1 or row.join.blank?
          row[1..7].each do |str|
              unless Encoding.compatible?(str,1.to_s)
                str = str.encode("UTF-8",undef: :replace)
              end
            end
          @uploadall[linenumber2] = row
          linenumber2 += 1 
        end
      end
      @importnumber = @uploadall.length + @uploadrel.length
     flash[:notice] = "Import successful !, #{@importnumber} ,records are imported.Data are saving..."
     # Delayed::Job.enqueue(UploadJob.new(@uploadall,@uploadrel,temp_release))
    end    
    respond_to do |format|
      format.html
      format.js
    end
    Checkman.upload_to_database(@uploadall,@uploadrel,temp_release)
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

end