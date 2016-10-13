class Canvas < ApplicationRecord
  belongs_to :project
  has_many :areas, dependent: :destroy

  before_create :create_canvas_areas

# Areas

  AREAS = [
    'Problem',
    'Solution',
    'Key metrics',
    'Unique Value Proposition',
    'Unfair advantage',
    'Customer segments',
    'Channels',
    'Cost structure',
    'Revenue streams'
  ]

  def self.get_list_of_areas
    list_of_areas = []
    AREAS.each do |area|
      list_of_areas << [area]
    end
    list_of_areas
  end

# Canvas qualitative indicators (from 0 to 4)

  CUSTOMER_PAIN_LEVEL = ['Very low', 'Low', 'Medium', 'High', 'Very high']

  def self.list_of_customer_pain_levels
    array_of_arrays = []
    CUSTOMER_PAIN_LEVEL.each_with_index do |word, index|
      array_of_arrays << [word, index]
    end
    array_of_arrays
  end

  def customer_pain_level_string
    if self.customer_pain_level.present?
      CUSTOMER_PAIN_LEVEL[self.customer_pain_level]
    else
      '-'
    end
  end

  MARKET_EASE_OF_REACH = ['Very low', 'Low', 'Medium', 'High', 'Very high']

  def self.list_of_market_ease_of_reach
    array_of_arrays = []
    MARKET_EASE_OF_REACH.each_with_index do |word, index|
      array_of_arrays << [word, index]
    end
    array_of_arrays
  end

  def market_ease_of_reach_string
    if self.market_ease_of_reach.present?
      MARKET_EASE_OF_REACH[self.market_ease_of_reach]
    else
      "-"
    end
  end

  FEASIBILITY = ['Very low', 'Low', 'Medium', 'High', 'Very high']

  def self.list_of_feasibility
    array_of_arrays = []
    FEASIBILITY.each_with_index do |word, index|
      array_of_arrays << [word, index]
    end
    array_of_arrays
  end

  def feasibility_string
    if self.feasibility.present?
      FEASIBILITY[self.feasibility]
    else
      "-"
    end
  end

  RISKINESS = ['Very low', 'Low', 'Medium', 'High', 'Very high']

  def self.list_of_riskiness
    create_select_list(Canvas::RISKINESS)
    # array_of_arrays = []
    # RISKINESS.each_with_index do |word, index|
    #   array_of_arrays << [word, index]
    # end
    # array_of_arrays
  end

  def riskiness_string
    if self.riskiness.present?
      RISKINESS[self.riskiness]
    else
      "-"
    end
  end

# ---- Private methods ----

  private

  def create_canvas_areas
    AREAS.each do |area|
      self.areas.build(name: area, area_identifier: area)
    end
  end

  def self.create_select_list(array_of_words)
    array_of_arrays = []
    array_of_words.each_with_index do |word, index|
      array_of_arrays << [word, index]
    end
    array_of_arrays
  end

end
