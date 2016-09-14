class Sprint < ApplicationRecord
  belongs_to :phase

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

end
