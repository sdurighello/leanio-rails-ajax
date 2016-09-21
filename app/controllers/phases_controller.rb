class PhasesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_phase, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :show]

  add_breadcrumb "Projects", :projects_path

  # GET /phases
  # GET /phases.json
  def index
    @phases = Phase.where(project_id: params[:project_id])
  end

  # GET /phases/1
  # GET /phases/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Phase #{@phase.sequence + 1}: #{@phase.name}", project_phase_path(@project, @phase)
  end

  # GET /phases/new
  def new
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "New Phase"

    sequence = @project.phases.empty? ? -1 : @project.phases.order(:sequence).last[:sequence]
    if sequence < (Project::PHASES.length - 1)
      # -1 will make sure that the first one is created as 0
      @phase = Phase.new(sequence: sequence + 1)
    else
      redirect_to project_path(@project.id), notice: 'New phase cannot be created'
    end
  end

  # GET /phases/1/edit
  def edit
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Phase #{@phase.sequence + 1}: #{@phase.name}", project_phase_path(@project, @phase)
  end

  # POST /phases
  # POST /phases.json
  def create
    @phase = Phase.new(phase_params)

    respond_to do |format|
      if @phase.save
        format.html { redirect_to project_phase_path(@project.id, @phase), notice: 'Phase was successfully created.' }
        format.json { render :show, status: :created, location: @phase }
      else
        format.html { render :new }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phases/1
  # PATCH/PUT /phases/1.json
  def update
    respond_to do |format|
      if @phase.update(phase_params)
        format.html { redirect_to project_phase_path(@project.id, @phase), notice: 'Phase was successfully updated.' }
        format.json { render :show, status: :ok, location: @phase }
      else
        format.html { render :edit }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phases/1
  # DELETE /phases/1.json
  def destroy
    @phase.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project.id), notice: 'Phase was successfully destroyed.' }
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
      phase = Phase.find(params[:id]) if params[:id].present? # For New / Create actions
      unless project.active
        flash[:error] = "This project is not active"
        if params[:id].present?
          redirect_to project_phase_path(project.id, phase), notice: 'This project is not active' # halts request cycle
        else
          redirect_to project_path(project), notice: 'This project is not active'
        end
      end
    end
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_phase
      @phase = Phase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phase_params
      params.require(:phase).permit(:project_id, :start_date, :end_date, :sequence, :number_of_sprints, :sprint_length, :completed)
    end
end
