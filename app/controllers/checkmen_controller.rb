require 'csv'
require 'upload_job'
# require 'checkmen_helper'

class CheckmenController < ApplicationController
  # GET /checkmen
  # GET /checkmen.json
  def index

     #@q = Checkman.search(params[:q])
     # @checkman = params[:distinct].to_i.zero? ? @q.result : @q.result(distinct: true)
     @q =Objectresponsible.search(params[:q])
     @objectresponsible = @q.result
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

    respond_to do |format|
      format.html
    end
  end

  # POST /checkmen_url
 # POST /checkmen.json
  def create
    # @checkman = Checkman.new(params[:checkman])
  end

  # PUT /checkmen/1
  # PUT /checkmen/1.json
  def update
    @checkman = Checkman.find(params[:id])
    @checkman.feedback = params[:checkman][:feedback]
    comment = Comment.create(
           :content => params[:checkman][:status],
           :checkman_id =>params[:id]
      )
    respond_to do |format|
      if @checkman.save
        format.html { redirect_to "/checkmen", notice: 'Checkman was successfully updated.' }
      else
        format.html { render action: "edit" }
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
     Checkman.delay.upload_to_database(@uploadall,@uploadrel,temp_release)
     # Delayed::Job.enqueue(UploadJob.new(@uploadall,@uploadrel,temp_release))
    end    
  end
  
  
  def search
    index  
    render :index
  end

end