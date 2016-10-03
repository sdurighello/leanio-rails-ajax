class Sprint < ApplicationRecord
  belongs_to :phase
  has_and_belongs_to_many :experiments

  HAPPINESS = ['Very low', 'Low', 'Medium', 'High', 'Very high']

  def stories_completion
    stories_completed = self.stories_completed ||= 0
    stories_estimated = self.stories_estimated ||= 0
    number = stories_completed - stories_estimated
    ratio = number.to_f != 0 ? number.to_f / self.stories_estimated : 0
    {number: number, ratio: ratio}
  end

  def points_completion
    points_completed = self.points_completed ||= 0
    points_estimated = self.points_estimated ||= 0
    number = points_completed - points_estimated
    ratio = number.to_f != 0 ? number.to_f / self.points_estimated : 0
    {number: number, ratio: ratio}
  end

  def update_experiment_assignment(experiment_id)
    begin
      experiment = Experiment.find(experiment_id)
      self.experiments.include?(experiment) ? self.experiments.delete(experiment) : self.experiments << experiment
      self.save!
    rescue
      self.errors.add :base, 'Experiment assignment cannot be updated'
      return false
    end
  end

end
