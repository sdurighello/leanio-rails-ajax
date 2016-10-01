require 'rails_helper'

describe Sprint do

  let(:project) { Project.create(name: 'project') }
  let(:phase) { Phase.create(sequence:0, project: project) }

  describe '#stories_completion' do
    let(:sprint) { Sprint.new(phase: phase, stories_estimated: 100, stories_completed: 90) }
    it 'returns the stories completion ratio and absolute variances' do
      expect(sprint.stories_completion).to eq({number: 90-100, ratio: -10.to_f/100})
    end
  end

  # describe '#update_experiment_assignment(experiment_id)' do
  #   let!(:experiment) { Experiment.create(phase: phase, name: 'experiment') }
  #   let!(:sprint_with_experiment) { Sprint.create(phase: phase) }
  #   let!(:sprint_without_experiment) { Sprint.create(phase: phase) }
  #
  #   before { sprint_with_experiment.experiment_ids << experiment.id }
  #
  #   it 'adds an experiment to the sprint if not added yet' do
  #     sprint_without_experiment.update_experiment_assignment(experiment.id)
  #     expect(sprint_without_experiment.experiments.length).to eq(1)
  #   end
  #   it 'removes an experiment from the sprint if already present' do
  #     sprint_with_experiment.update_experiment_assignment(experiment.id)
  #     expect(sprint_with_experiment.experiments).to be_empty
  #   end
  # end

end
