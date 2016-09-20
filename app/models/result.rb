class Result < ApplicationRecord
  belongs_to :experiment
  belongs_to :hypothesis

  LEVELS = ['Very low', 'Low', 'Medium', 'High', 'Very high']

  def self.get_list_of_levels
    list_of_levels = []
    PHASES.each_with_index do |level, index|
      list_of_levels << [level, index]
    end
    list_of_levels
  end



end
