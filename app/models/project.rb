class Project < ApplicationRecord
  has_many :phases
  has_many :teams
end
