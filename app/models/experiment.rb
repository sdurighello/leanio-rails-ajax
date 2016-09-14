class Experiment < ApplicationRecord
  belongs_to :phase

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
