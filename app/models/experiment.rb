class Experiment < ApplicationRecord
  belongs_to :phase
  has_and_belongs_to_many :sprints

  validates :name, presence: true, if: -> { required_for_step?(:header) }

  # Multi step form wicked

  # class attribute accessor
  cattr_accessor :form_steps do
    %w(header description result)
  end

  # instance level accessor to know in which step are we
  attr_accessor :form_step

  def required_for_step?(form_step)
    # All fields are required if no form step is present
    return true if form_step.nil?

    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if self.form_steps.index(form_step.to_s) { self.form_steps.index(form_step) }
  end


  # ----------------------


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


end
