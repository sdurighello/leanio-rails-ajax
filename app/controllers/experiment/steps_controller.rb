class Experiment::StepsController < ApplicationController

  include Wicked::Wizard

  steps :identity, :characteristics, :instructions

  add_breadcrumb "Add new experiment"

  def show
    add_breadcrumb "#{params[:id]}"
    @project = Project.find(params[:project_id])
    @phase = Phase.find(params[:phase_id])
    @experiment = Experiment.find(params[:experiment_id])
    render_wizard
  end

  def update
  end
end
