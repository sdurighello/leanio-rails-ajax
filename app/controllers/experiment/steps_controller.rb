class Experiment::StepsController < ApplicationController

  include Wicked::Wizard

  steps :header, :description, :result

  def finish_wizard_path
    project_phase_experiment_path(@project.id, @phase.id, @experiment)
  end

  add_breadcrumb "Add new experiment"

  def show
    add_breadcrumb "#{params[:id]}"
    @project = Project.find(params[:project_id])
    @phase = Phase.find(params[:phase_id])
    @experiment = Experiment.find(params[:experiment_id])
    render_wizard
  end

  def update
    add_breadcrumb "#{params[:id]}"
    @project = Project.find(params[:project_id])
    @phase = Phase.find(params[:phase_id])
    @experiment = Experiment.find(params[:experiment_id])
    @experiment.update(experiment_params(step))
    render_wizard @experiment
  end


  private

  def experiment_params(step)
    permitted_attributes = case step
    when :header
        [:phase_id, :name, :start_date, :end_date, :completed]
      when :description
        [:domain, :assumption, :method, :action, :oservation, :success_criteria, :measure]
      when :result
        [:learned, :interviews_planned, :interviews_done, :early_adopters_planned, :early_adopters_converted]
      end
    params.require(:experiment).permit(permitted_attributes).merge(form_step: step)
  end

end
