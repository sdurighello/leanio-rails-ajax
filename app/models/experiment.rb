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

  def self.status
    %w(Red Amber Green)
  end

  # Price acceptance

  PRICE_ACCEPTANCE = ['1 - Very low', '2 - Low', '3 - Medium', '4 - High', '5 - Very high']

  def self.list_of_price_acceptance
    list_of_values = []
    PRICE_ACCEPTANCE.each_with_index do |v, i|
      list_of_values << [v, i]
    end
    list_of_values
  end

  def price_acceptance_string
    if self.price_acceptance.present?
      PRICE_ACCEPTANCE[self.price_acceptance]
    end
  end

  # Sean Ellis Test

  SEAN_ELLIS_TEST = ['1 - Very disappointed', '2 - Somewhat disappointed', '3 - Not disappointed', '4 - N/A']

  def self.list_of_sean_ellis_test
    list_of_values = []
    SEAN_ELLIS_TEST.each_with_index do |v, i|
      list_of_values << [v, i]
    end
    list_of_values
  end

  def sean_ellis_test_string
    if self.sean_ellis_test.present?
      SEAN_ELLIS_TEST[self.sean_ellis_test]
    end
  end

  # Hypotheses add/remove

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

  # Start date - End date - Duration (in days)

  def start_date
    earliest_date_sprint = (self.sprints).min_by { |s| s.start_date} if !self.sprints.empty?
    if earliest_date_sprint.present?
      earliest_date_sprint.start_date
    else
      nil
    end
  end

  def end_date
    latest_date_sprint = (self.sprints).max_by { |s| s.end_date} if !self.sprints.empty?
    if latest_date_sprint.present?
      latest_date_sprint.end_date
    else
      nil
    end
  end

  def duration
    (self.end_date - self.start_date).to_i if (self.start_date.present? && self.end_date.present?)
  end

  # -------- Private --------

  private



end
