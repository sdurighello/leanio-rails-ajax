class ExperimentsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_member
  before_action :set_project
  before_action :set_phase
  before_action :set_experiment, except: [:index, :new, :create]
  before_action :project_is_active, except: [:index, :show]
  before_action :set_experiment_type

  add_breadcrumb "Projects", :projects_path

  # Adding / Removing HYPOTHESES to/from experiments
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

  # Adding / Removing USERS to/from experiments
  def add_user
    if @experiment.add_user(params[:user_id].to_i)
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'User was successfully added'
    else
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'User cannot be added'
    end
  end

  def remove_user
    if @experiment.remove_user(params[:user_id].to_i)
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'User was successfully removed'
    else
      redirect_to project_phase_experiment_path(@project.id, @phase.id, @experiment), notice: 'User cannot be removed'
    end
  end

  # GET /experiments
  # GET /experiments.json
  def index
    @experiments =  experiment_type_class.where(phase_id: params[:phase_id])
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
    add_breadcrumb "New #{@experiment_type.underscore.split('_').join(' ')}"
    @experiment = experiment_type_class.new
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
      unless (current_user.id == project.created_by.id) || (project.users.any? { |u| u.id == current_user.id  })
        flash[:error] = "You are not a member of this project"
        redirect_to projects_path, notice: 'You are not a member of this project' # halts request cycle
      end
    end
    def project_is_active
      project = Project.find(params[:project_id])
      phase = Phase.find(params[:phase_id])
      experiment = Experiment.find(params[:id]) if params[:id].present?
      unless project.active
        flash[:error] = "This project is not active"
        if params[:id].present?
          redirect_to project_phase_experiment_path(project.id, phase.id, experiment), notice: 'This project is not active' # halts request cycle
        else
          redirect_to project_phase_path(project.id, phase), notice: 'This project is not active'
        end
      end
    end
    def set_project
      @project = Project.find(params[:project_id])
    end
    def set_phase
      @phase = Phase.find(params[:phase_id])
    end
    def set_experiment
      @experiment = experiment_type_class.find(params[:id])
    end

    def set_experiment_type
     @experiment_type = experiment_type
    end
    def experiment_type
      Experiment.experiment_types.include?(params[:type]) ? params[:type] : "Experiment"
    end
    def experiment_type_class
      experiment_type.constantize
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experiment_params
      params.require(experiment_type.underscore.to_sym).permit(
      :project_id,
      :phase_id,
      {hypothesis_ids: []},
      :type,
      :name, :description, :completed, :status,
      :interviews_planned, :interviews_done, :early_adopters_planned, :early_adopters_converted,
      :today_solution,
      :price_proposed,
      :price_acceptance,
      :price_revised,
      :sean_ellis_test,
      results_attributes: [:id, :level, :comment])
    end
end
