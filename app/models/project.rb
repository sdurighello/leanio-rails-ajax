class Project < ApplicationRecord

  has_many :phases, inverse_of: :project
  has_many :teams

  accepts_nested_attributes_for :phases, allow_destroy: true, reject_if: :all_blank

  PHASES = ['Problem/Solution Fit', 'Product/Market Fit', 'Scale']

  def self.get_list_of_phases
    list_of_phases = []
    PHASES.each_with_index do |phase, index|
      list_of_phases << [phase, index]
    end
    list_of_phases
  end

  def self.get_project_phases
    project_phases = []
    PHASES.each_with_index do |phase, index|
      project_phase = Phase.find_by sequence: index
      project_phases << [project_phase.name, project_phase.id]
    end
    project_phases
  end

  def current_phase
    Phase.find(self.current_phase_id)
  end

end
