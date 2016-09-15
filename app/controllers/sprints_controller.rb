class SprintsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:index, :show, :new, :edit, :create, :update, :destroy, :update_experiment_assignment]
  before_action :set_phase, only: [:index, :show, :new, :edit, :create, :update, :destroy, :update_experiment_assignment]
  before_action :set_sprint, only: [:show, :edit, :update, :destroy, :update_experiment_assignment]

  # GET /sprints
  # GET /sprints.json
  def index
    @sprints = Sprint.where(phase_id: params[:phase_id])
  end

  # GET /sprints/1
  # GET /sprints/1.json
  def show
  end

  # GET /sprints/new
  def new
    @sprint = Sprint.new
  end

  # GET /sprints/1/edit
  def edit
  end

  # POST /sprints
  # POST /sprints.json
  def create
    @sprint = Sprint.new(sprint_params)

    respond_to do |format|
      if @sprint.save
        format.html { redirect_to project_phase_sprint_path(@project.id, @phase.id, @sprint), notice: 'Sprint was successfully created.' }
        format.json { render :show, status: :created, location: @sprint }
      else
        format.html { render :new }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_experiment_assignment
    if @sprint.update_experiment_assignment(params[:experiment_id])
      redirect_to project_phase_sprint_path(@project.id, @phase.id, @sprint), notice: 'Experiment assignment was successfully updated.'
    else
      redirect_to project_phase_sprint_path(@project.id, @phase.id, @sprint), notice: 'Could not update the experiment assignment'
    end
  end

  # PATCH/PUT /sprints/1
  # PATCH/PUT /sprints/1.json
  def update
    respond_to do |format|
      if @sprint.update(sprint_params)
        format.html { redirect_to project_phase_sprint_path(@project.id, @phase.id, @sprint), notice: 'Sprint was successfully updated.' }
        format.json { render :show, status: :ok, location: @sprint }
      else
        format.html { render :edit }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sprints/1
  # DELETE /sprints/1.json
  def destroy
    @sprint.destroy
    respond_to do |format|
      format.html { redirect_to project_phase_sprint_path(@project.id, @phase.id), notice: 'Sprint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_phase
      @phase = Phase.find(params[:phase_id])
    end
    def set_sprint
      @sprint = Sprint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sprint_params
      params.require(:sprint).permit(:project_id, :phase_id, :start_date, :end_date, :completed, :things_done, :things_learned, :stories_estimated, :stories_completed, :points_estimated, :points_completed, :happiness, :impediments)
    end
end
