class Area < ApplicationRecord
  belongs_to :canvas
  has_and_belongs_to_many :hypotheses
end
