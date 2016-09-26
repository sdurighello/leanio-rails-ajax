class Team < ApplicationRecord
  belongs_to :project
  has_many :team_members, dependent: :destroy
end
