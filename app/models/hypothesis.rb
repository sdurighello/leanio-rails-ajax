class Hypothesis < ApplicationRecord
  belongs_to :project
  has_many :results, dependent: :destroy
  has_many :experiments, through: :results # TODO add 'dependent: :destroy, :nullify' to delete result if hypothesis is deleted but experiement stays and ref in experiment is set to null
  has_and_belongs_to_many :areas
end
