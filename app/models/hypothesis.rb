class Hypothesis < ApplicationRecord
  has_many :experiments, through :results
end
