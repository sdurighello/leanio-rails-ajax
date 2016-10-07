class ResultsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_result, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :show]

  add_breadcrumb "Projects", :projects_path

  # GET /results
  # GET /results.json
  def index
    @results = Result.where(project_id: params[:project_id])
  end

  # GET /results/1
  # GET /results/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Result -> [#{@result.hypothesis.name}] / [#{@result.experiment.name}]", project_result_path(@project, @result)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /results/new
  def new
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "New Result"
    @result = Result.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /results/1/edit
  def edit
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Result -> [#{@result.hypothesis.name}] / [#{@result.experiment.name}]", project_result_path(@project, @result)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to project_result_path(@project.id, @result), notice: 'Result was successfully created.' }
        format.json { render json: @result, status: :ok }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to project_result_path(@project.id, @result), notice: 'Result was successfully updated.' }
        format.json { render json: @result, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project.id), notice: 'Result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_is_member
      project = Project.find(params[:project_id])
      unless (current_user.id == project.created_by.id) || (project.users.any? { |u| u.id == current_user.id  })
        flash[:error] = "You are not a member of this project"
        redirect_to projects_path, notice: 'You are not a member of this project' # halts request cycle
      end
    end
    def project_is_active
      project = Project.find(params[:project_id])
      result = Result.find(params[:id]) if params[:id].present?
      unless project.active
        flash[:error] = "This project is not active"
        if params[:id].present?
          redirect_to project_result_path(project.id, result), notice: 'This project is not active' # halts request cycle
        else
          redirect_to project_path(project), notice: 'This project is not active'
        end
      end
    end
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_result
      @result = Result.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:level, :comment, :experiment_id, :hypothesis_id)
    end
end
