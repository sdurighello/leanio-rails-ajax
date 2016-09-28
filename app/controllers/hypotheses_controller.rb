class HypothesesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_hypothesis, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :show]

  add_breadcrumb "Projects", :projects_path

  # GET /hypotheses
  # GET /hypotheses.json
  def index
    @hypotheses = Hypothesis.where(project_id: params[:project_id])
  end

  # GET /hypotheses/1
  # GET /hypotheses/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Hypothesis: #{@hypothesis.name}", project_hypothesis_path(@project, @hypothesis)
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /hypotheses/new
  def new
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "New Hypothesis"
    @hypothesis = Hypothesis.new
  end

  # GET /hypotheses/1/edit
  def edit
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Hypothesis: #{@hypothesis.name}", project_hypothesis_path(@project, @hypothesis)
  end

  # POST /hypotheses
  # POST /hypotheses.json
  def create
    @hypothesis = Hypothesis.new(hypothesis_params)

    respond_to do |format|
      if @hypothesis.save
        format.html { redirect_to project_hypothesis_path(@project.id, @hypothesis), notice: 'Hypothesis was successfully created.' }
        format.json { render :show, status: :created, location: @hypothesis }
      else
        format.html { render :new }
        format.json { render json: @hypothesis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hypotheses/1
  # PATCH/PUT /hypotheses/1.json
  def update
    respond_to do |format|
      if @hypothesis.update(hypothesis_params)
        format.html { redirect_to project_hypothesis_path(@project.id, @hypothesis), notice: 'Hypothesis was successfully updated.' }
        format.json { render :show, status: :ok, location: @hypothesis }
      else
        format.html { render :edit }
        format.json { render json: @hypothesis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hypotheses/1
  # DELETE /hypotheses/1.json
  def destroy
    @hypothesis.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project.id), notice: 'Hypothesis was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_is_member
      project = Project.find(params[:project_id])
      unless (current_user.id == project.created_by) || (project.users.any? { |u| u.id == current_user.id  })
        flash[:error] = "You are not a member of this project"
        redirect_to projects_path, notice: 'You are not a member of this project' # halts request cycle
      end
    end
    def project_is_active
      project = Project.find(params[:project_id])
      hypothesis = Hypothesis.find(params[:id]) if params[:id].present?
      unless project.active
        flash[:error] = "This project is not active"
        if params[:id].present?
          redirect_to project_hypothesis_path(project.id, hypothesis), notice: 'This project is not active' # halts request cycle
        else
          redirect_to project_path(project), notice: 'This project is not active'
        end
      end
    end
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_hypothesis
      @hypothesis = Hypothesis.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hypothesis_params
      params.require(:hypothesis).permit(:project_id, :area_identifier, :name, :description)
    end
end
