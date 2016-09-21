class ExperimentsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_phase
  before_action :set_experiment, except: [:index, :new, :create]

  add_breadcrumb "Projects", :projects_path

  # Adding / Removing hypotheses to/from experiments
  def add_hypothesis
    if @experiment.add_hypothesis(params[:hypothesis_id].to_i)
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'Hypothesis was successfully added'
    else
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'Hypothesis cannot be added'
    end
  end

  def remove_hypothesis
    if @experiment.remove_hypothesis(params[:result_id].to_i)
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'Hypothesis was successfully removed'
    else
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'Hypothesis cannot be removed'
    end
  end

  # GET /experiments
  # GET /experiments.json
  def index
    @experiments =  Experiment.where(phase_id: params[:phase_id])
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Phase #{@phase.sequence + 1}: #{@phase.name}", project_phase_path(@project, @phase)
    add_breadcrumb "Experiment: #{@experiment.name}"
  end

  # GET /experiments/new
  def new
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Phase #{@phase.sequence + 1}: #{@phase.name}", project_phase_path(@project, @phase)
    add_breadcrumb "New Experiment"
    @experiment = Experiment.new
  end

  # GET /experiments/1/edit
  def edit
    add_breadcrumb "Project: #{@project.name}", project_path(@project)
    add_breadcrumb "Phase #{@phase.sequence}: #{@phase.name}", project_phase_path(@project, @phase)
    add_breadcrumb "Experiment: #{@experiment.name}"
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @experiment = Experiment.new(experiment_params)

    respond_to do |format|
      if @experiment.save
        format.html { redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'Experiment was successfully created.' }
        format.json { render :show, status: :created, location: @experiment }
      else
        format.html { render :new }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /experiments/1
  # PATCH/PUT /experiments/1.json
  def update
    respond_to do |format|
      if @experiment.update(experiment_params)
        format.html { redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'Experiment was successfully updated.' }
        format.json { render :show, status: :ok, location: @experiment }
      else
        format.html { render :edit }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.json
  def destroy
    @experiment.destroy
    respond_to do |format|
      format.html { redirect_to project_phase_path(@project.id, @phase.id), notice: 'Experiment was successfully destroyed.' }
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
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_phase
      @phase = Phase.find(params[:phase_id])
    end
    def set_experiment
      @experiment = Experiment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experiment_params
      params.require(:experiment).permit(
      :project_id,
      :phase_id,
      {hypothesis_ids: []},
      :name, :description, :completed, :interviews_planned,
      :interviews_done, :early_adopters_planned, :early_adopters_converted,
      results_attributes: [:id, :level, :comment])
    end
end
