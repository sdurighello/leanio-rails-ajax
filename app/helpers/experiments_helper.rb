module ExperimentsHelper

  # Returns a dynamic path based on the provided parameters

  def sti_experiment_path(project_id, phase_id, experiment_type = "experiment", experiment = nil, action = nil)
    p "#{project_id} - #{phase_id} - #{experiment_type} - #{experiment.name} - #{action}"
    send "#{format_sti(action, experiment_type, experiment)}_path", {project_id: project_id, phase_id: phase_id, id: experiment.id}
  end

  def format_sti(action, experiment_type, experiment)
    if action || experiment
      "#{format_action(action)}project_phase_#{experiment_type.underscore}"
    else
      "project_phase_#{experiment_type.underscore.pluralize}"
    end
  end

  def format_action(action)
    action ? "#{action}_" : ""
  end

end
