class Experiment < ApplicationRecord
  belongs_to :phase
  has_many :results, dependent: :destroy
  has_many :hypotheses, through: :results
  has_and_belongs_to_many :sprints
  has_and_belongs_to_many :users

  validates :users, inclusion: { in: :project_users,
    message: "%{value} is not a project user" }, allow_nil: true

  accepts_nested_attributes_for :results

  def add_hypothesis(hypothesis_id)
    if Result.find_by(experiment_id:self.id, hypothesis_id: hypothesis_id).present?
      self.errors.add :base, 'This hypothesis has been already added'
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
      self.errors.add :base, 'This hypothesis cannot be added'
      return false
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

  private

  def project_users
    self.phase.project.users
  end


end
