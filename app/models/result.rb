class Result < ApplicationRecord
  belongs_to :experiment
  belongs_to :hypothesis
end
