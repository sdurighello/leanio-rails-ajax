require 'rails_helper'

describe Sprint do

  project = Project.create(name: 'project')
  phase = Phase.create(sequence:0, project: project)

  describe '#stories_completion' do
    sprint = Sprint.new(phase: phase, stories_estimated: 100, stories_completed: 90)
    it 'returns the stories completion ratio and absolute variances' do
      expect(sprint.stories_completion).to eq({number: 90-100, ratio: -10.to_f/100})
    end
  end

  describe '#update_experiment_assignment(experiment_id)' do
    experiment = Experiment.create(phase: phase, name: 'experiment')
    p experiment
    sprint_with_experiment = Sprint.create(phase: phase, experiments: [experiment])
    sprint_without_experiment = Sprint.create(phase: phase)
    it 'adds an experiment to the sprint if not added yet' do
      expect(sprint_without_experiment.update_experiment_assignment(experiment.id)).experiments.length.to eq(1)
    end
    it 'removes an experiment from the sprint if already present' do
      expect(sprint_with_experiment.update_experiment_assignment(experiment.id)).experiments.empty?.to eq(true)
    end
  end

end
