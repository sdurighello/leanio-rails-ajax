class Phase < ApplicationRecord
  belongs_to :project
  has_many :experiments
  has_many :sprints

  def name
    Project::PHASES[self.sequence]
  end

end
