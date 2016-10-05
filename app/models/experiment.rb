class Experiment < ApplicationRecord
  belongs_to :phase
  has_many :results, dependent: :destroy
  has_many :hypotheses, through: :results
  has_and_belongs_to_many :sprints
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :results

  def self.experiment_types
    %w(ProblemExperiment SolutionExperiment ProductExperiment CustomerExperiment)
  end

  def add_hypothesis(hypothesis_id)
    if Result.find_by(experiment_id:self.id, hypothesis_id: hypothesis_id).present?
      self.errors.add :base, 'This hypothesis has already been added'
      return false
    else
      begin
        self.results.build(hypothesis_id: hypothesis_id)
        self.save!
      rescue
        self.errors.add :base, 'This hypothesis cannot be added'
        return false
      end
    end
  end

  def remove_hypothesis(result_id)
    begin
      result = Result.find(result_id)
      Result.destroy(result.id)
    rescue
      self.errors.add :base, 'This hypothesis cannot be removed'
      return false
    end
  end

  def add_user(user_id)
    user = User.find_by(id: user_id)
    if !self.phase.project.users.include?(user)
      self.errors.add :base, 'This user is not a project user'
      return false
    elsif self.users.include?(user)
      self.errors.add :base, 'This user has already been added'
      return false
    else
      begin
        self.users << user
        self.save!
      rescue
        self.errors.add :base, 'This user cannot be added'
        return false
      end
    end
  end

  def remove_user(user_id)
    user = User.find_by(id: user_id)
    if !self.users.include?(user)
      self.errors.add :base, 'This user was not added to the experiment'
      return false
    else
      begin
        self.users.destroy(user)
        self.save!
      rescue
        self.errors.add :base, 'This user cannot be removed'
        return false
      end
    end
  end

  def interviews_completion
    interviews_done = self.interviews_done ||= 0
    interviews_planned = self.interviews_planned ||= 0
    number = interviews_done - interviews_planned
    ratio = number.to_f != 0 ? number.to_f / self.interviews_planned : 0
    {number: number, ratio: ratio}
  end

  def early_adopters_conversion
    early_adopters_converted = self.early_adopters_converted ||= 0
    early_adopters_planned = self.early_adopters_planned ||= 0
    number = early_adopters_converted - early_adopters_planned
    ratio = number.to_f != 0 ? number.to_f / self.early_adopters_planned : 0
    {number: number, ratio: ratio}
  end

  # To be used in grouped select as grouped_options_for_select
  def hypothesis_for_grouped_select
    # Get only hypotheses that have not yet been associated with this experiment
    h_not_associated = Hypothesis.includes(:experiments).where(experiments: {id: nil})
    h_not_this_experiment = Hypothesis.includes(:experiments).where.not(experiments: {id: self.id})
    all_hypotheses = (h_not_associated + h_not_this_experiment)
    # Create grouped hash of arrays
    select_hash = {}
    Canvas::AREAS.each do |area|
      select_hash[area] = []
    end
    all_hypotheses.each do |h|
      select_hash[h.area_identifier] << [h.name, h.id]
    end
    select_hash
  end

end
