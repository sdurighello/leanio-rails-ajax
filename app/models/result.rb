class Result < ApplicationRecord
  belongs_to :experiment
  belongs_to :hypothesis

  VALIDATION_LEVELS = ['1 - Very low', '2 - Low', '3 - Medium', '4 - High', '5 - Very high']
  PAIN_LEVELS = ['1 - Very low', '2 - Low', '3 - Medium', '4 - High', '5 - Very high']
  PRIORITIES = ['1 - Very low', '2 - Low', '3 - Medium', '4 - High', '5 - Very high']

# Select list_of_values

  def self.list_of_validation_levels
    list_of_values = []
    VALIDATION_LEVELS.each_with_index do |v, i|
      list_of_values << [v, i]
    end
    list_of_values
  end

  def self.list_of_pain_levels
    list_of_values = []
    PAIN_LEVELS.each_with_index do |v, i|
      list_of_values << [v, i]
    end
    list_of_values
  end

  def self.list_of_priorities
    list_of_values = []
    PRIORITIES.each_with_index do |v, i|
      list_of_values << [v, i]
    end
    list_of_values
  end

# Constant values as strings

  def validation_level_string
    if self.validation_level.present?
      VALIDATION_LEVELS[self.validation_level]
    end
  end

  def pain_level_string
    if self.pain_level.present?
      PAIN_LEVELS[self.pain_level]
    end
  end

  def priority_string
    if self.priority.present?
      PRIORITIES[self.priority]
    end
  end



end
