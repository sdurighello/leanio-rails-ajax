class Hypothesis < ApplicationRecord
  belongs_to :project
  has_many :results, dependent: :destroy
  has_many :experiments, through: :results
  has_and_belongs_to_many :areas


end
