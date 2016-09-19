class Canvas < ApplicationRecord
  belongs_to :project
  has_many :areas, dependent: :destroy

  before_create :create_canvas_areas

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
    AREAS.each do |area, index|
      list_of_areas << [area]
    end
    list_of_areas
  end

  private

  def create_canvas_areas
    AREAS.each do |area|
      self.areas.build(name: area, area_identifier: area)
    end
  end

end
