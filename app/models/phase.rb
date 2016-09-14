class Phase < ApplicationRecord
  belongs_to :project
  has_many :experiments
  has_many :sprints
end
