class CriterionsController < ApplicationController
  # require 'json'
  # require 'pry'

  include ActionController::MimeResponds
  include ActionController::Helpers
  include ActionController::Cookies
  # include ActionController::ImplicitRender
  # GET /criterions
  # GET /criterions.json
  def index
    @teaminfo = Teaminfo.all
    respond_to do |format|
      format.json { render json: @teaminfo.as_json(
        except: [:created_at,:updated_at],
        # :include=>{
        #   :projectinfos=>{only:[:projectID],
        #     :include=>{
        #       :criterions=>{
        #         only:[:id],
        #         :include=>{
        #           :taktinfos=>{
        #             only:[:start_time,:end_time],
        #             :include=>{
        #               :testplans=>{
        #                 except:[:created_at]
        #               }
        #             }
        #           }
        #         }
        #       }
        #     }
        #   }
        # },
        ),
        :callback => params[:callback] }
     end
  end

  # GET /criterions/1
  # GET /criterions/1.json
  def show
    @teaminfo = Teaminfo.find(params[:id])
    @projectinfo = @teaminfo.projectinfos 
    respond_to do |format|
      format.json { render json: @projectinfo.as_json(except: [:created_at,:updated_at]),:callback => params[:callback] }
     end
  end

  #get/takt information
  def get_takt

    # session[:projectid] = params[:id]#{:value => params[:id] ,:expires => 2.hour.from_now}
    @criterion = Criterion.where(:teaminfo_id => params[:teamid],:projectinfo_id => params[:id])
    @takts = @criterion[0].taktinfos
    respond_to do |format|
      format.json{render json:@takts.as_json(except: [:created_at,:updated_at],),:callback => params[:callback]}
    end
  end

  def new_takt
     # @criterion = Criterion.where(:teaminfo_id => params[:teamid],:projectinfo_id => params[:projectid])
     @takt = Taktinfo.first#Taktinfo.new()
     # @takt.criterion_id = @criterion.id
     # @takt.end_time = params[:end_time]
     # @takt.start_time =params[:start_time]
     # @takt.reporter = params[:reporter]
     # @takt.taktID = params[:taktID]
     # @takt.save

     respond_to do |format|
      format.json{render json:@takt.as_json(root:false,only:[:id]),callback =>params[:callback]}
     end
  end

  def get_detail
    @takt = Taktinfo.find(params[:id])
    respond_to do |format|
      format.json{render json: @takt.as_json(
          only:[:start_time,:end_time,:reporter],
          :include=>{
            :criterion=>{only:[:status],
              :include=>{
                :teaminfo=>{except:[:created_at,:updated_at]},
                :projectinfo=>{only:[:projectID,:jira]}
              }
            }
          }
        ),:callback =>params[:callback]}
    end
  end

  # get test plan for selected TAKT
  def get_test_plan
    @takt = Taktinfo.find(params[:id])
    @testplans = @takt.testplans.where(:format =>params[:testp])

    respond_to do |format|
      format.json{render json:@testplans.as_json(root:false),:callback =>params[:callback]}
    end
  end

  #new a test plan for selected TAKT
  def create_test_plan
    @testplan = Testplan.new()
    @testplan.plan_name = params[:plan_name]
    @testplan.test_type = params[:test_type]
    @testplan.reporter  = params[:reporter]
    @testplan.coverage = params[:coverage]
    @testplan.ok_rate  = params[:ok_rate]
    @testplan.open_message =params[:open_message].to_i
    @testplan.comment =params[:comment]
    @testplan.taktinfo_id = params[:id]
    @testplan.format = params[:testp]
    if params[:coverage].to_i > 80 && params[:ok_rate].to_i> 80
      @testplan.status = "Green"
    else
       @testplan.status = "Red"
    end
    @testplan.save

    @takt = Taktinfo.find(params[:id])
    @testplans = @takt.testplans.where(:format =>params[:testp])

    respond_to do |format|
      format.json{render json:@testplans.as_json(root:false),:callback =>params[:callback]}
    end
  end

  def edit_test_plan
    @testplan = Testplan.find(params[:id])
    @testplan.plan_name = params[:plan_name]
    @testplan.test_type = params[:test_type]
    @testplan.reporter  = params[:reporter]
    @testplan.coverage = params[:coverage]
    @testplan.ok_rate  = params[:ok_rate]
    @testplan.open_message =params[:open_message].to_i
    @testplan.comment =params[:comment]
    @testplan.taktinfo_id = params[:taktinfo_id]
    @testplan.format = params[:testp]
    if params[:coverage].to_i > 80 && params[:ok_rate].to_i> 80
      @testplan.status = "Green"
    else
       @testplan.status = "Red"
    end
    @testplan.save

    @takt = Taktinfo.find(params[:taktinfo_id])
    @testplans = @takt.testplans.where(:format =>params[:testp])

    respond_to do |format|
      format.json{render json:@testplans.as_json(root:false),:callback =>params[:callback]}
    end
  end

  def delete_test_plan
      @testplan = Testplan.find(params[:id])
      @testplan.delete
     @takt = Taktinfo.find(params[:taktinfo_id])
     @testplans = @takt.testplans.where(:format =>params[:testp])

    respond_to do |format|
      format.json{render json:@testplans.as_json(root:false),:callback =>params[:callback]}
    end
  end

  def over_view
    @testplans = Testplan.all
    @teaminfos = Teaminfo.all
    @projectinfos =Projectinfo.all
    respond_to do |format|
      format.json{render :json=>{
        :testplans=>@testplans.as_json(root:false), 
        :teaminfos=>@teaminfos.as_json(root:false,only:[:team_name,:id]),
        :project  =>@projectinfos.as_json(root:false,only:[:projectID,:id])
        },:callback =>params[:callback]}
    end
  end

  def store_jira
    @fixVersion = params[:fixVersion]
    @jira_project = params[:jira_project]
    # @versionName = params[:versionName]
    # binding.pry
    respond_to do |format|
      format.html
    end
  end
  

  def get_jira
    @issues  = Bil.where("version_id = ? AND project_name =? ",params[:fixVersion],params[:jira_project])
    respond_to do |format|
     format.json {render json:@issues.as_json(root:false),:callback => params[:callback]}
    end
  end

  def save_jira
    @history = Bil.where("version_id = ? AND project_name =? ",params[:fixVersion],params[:project])
    if !@history.blank?
      @history.delete_all
    end
    @versionNumber = params["issues"]["issues"]["0"]["fields"]["fixVersions"].length
    (0...@versionNumber).each do |n|
      if params["issues"]["issues"]["0"]["fields"]["fixVersions"][n.to_s]["id"].to_s == params["fixVersion"].to_s
        @versionName = params["issues"]["issues"]["0"]["fields"]["fixVersions"][n.to_s]["name"]
      end
    end
    @json_length = params[:issues][:total].to_i 
    (0...@json_length).each do |i|
     # @i= params[:fixVersion]
     Bil.create(
       :issue_key   => params["issues"]["issues"][i.to_s]["key"],
       :issue_type  => params["issues"]["issues"][i.to_s]["fields"]["issuetype"]["name"],
       :summary     => params["issues"]["issues"][i.to_s]["fields"]["summary"],
       :version_id  => params["fixVersion"],
       :version_name=> @versionName,
       :priority    => params["issues"]["issues"][i.to_s]["fields"]["priority"]["name"],
       :assignee    => params["issues"]["issues"][i.to_s]["fields"]["assignee"]["displayName"],
       :reporter    => params["issues"]["issues"][i.to_s]["fields"]["reporter"]["displayName"],
       :status      => params["issues"]["issues"][i.to_s]["fields"]["status"]["name"],
       :descript    => params["issues"]["issues"][i.to_s]["fields"]["description"],
       :project_key => params["issues"]["issues"][i.to_s]["fields"]["project"]["key"],
       :project_id  => params["issues"]["issues"][i.to_s]["fields"]["project"]["id"],
       :project_name=> params["issues"]["issues"][i.to_s]["fields"]["project"]["name"]
      )
    end
    # binding.pry
    render :js=>"alert('All has been saved');"
    
  end

  def get_all_jira
    @issues = Bil.all
    respond_to do |format|
      format.json {render json:@issues.as_json(root:false),:callback=>params[:callback]}
    end
  end

  def maintain
    @teaminfo = Teaminfo.where("team_name = ?",params[:team])
    if @teaminfo.blank?
      @teaminfo = Teaminfo.new
      @teaminfo.team_name = params[:team]
      @teaminfo.save
      @teamid = @teaminfo.id
    else
      @teamid= @teaminfo.first.id
    end

    @project = Projectinfo.where("jira = ?",params[:jira])

    if @project.blank?
      @project = Projectinfo.new
      @project.jira = params[:jira]
      @project.projectID = params[:project]
      @project.save
      @projectid = @project.id
    else
      @projectid = @project.first.id
    end

    @criterion = Criterion.where("teaminfo_id =? AND projectinfo_id = ?",@teamid,@projectid)

    if @criterion.blank?
      @criterion.create(
        :teaminfo_id => @teamid,
        :projectinfo_id =>@projectid
        )
    end
    @team = Teaminfo.all
    respond_to do |format|
      format.json{render json:@team.as_json(),:callback=>params[:callback]}
    end
  end
  # GET /criterions/new
  # GET /criterions/new.json
  def new
    @criterion = Criterion.new
    render json: @criterion
  end

  # POST /criterions
  # POST /criterions.json
  def create
    @criterion = Criterion.new(params[:criterion])

    if @criterion.save
      render json: @criterion, status: :created, location: @criterion
    else
      render json: @criterion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /criterions/1
  # PATCH/PUT /criterions/1.json
  def update
    @criterion = Criterion.find(params[:id])

    if @criterion.update_attributes(params[:criterion])
      head :no_content
    else
      render json: @criterion.errors, status: :unprocessable_entity
    end
  end



  # DELETE /criterions/1
  # DELETE /criterions/1.json
  def destroy
    @criterion = Criterion.find(params[:id])
    @criterion.destroy

    head :no_content
  end
end
