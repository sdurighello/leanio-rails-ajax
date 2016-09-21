class Project < ApplicationRecord
  has_many :canvases, dependent: :destroy
  has_many :phases, inverse_of: :project, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :hypotheses, dependent: :destroy
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :phases, allow_destroy: true, reject_if: :all_blank

  before_create :set_membership

  # --- Constants

  PHASES = ['Problem/Solution Fit', 'Product/Market Fit', 'Scale']

  # --- Class methods

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

  def self.set_current_phase(project_id, phase_id)
    project = Project.find(project_id)
    project.current_phase_id = phase_id
    project.save
  end

  # --- Instance methdos

  def current_phase
    Phase.find(self.current_phase_id)
  end

  def is_member?(user)
    return true if user.id == self.created_by
    self.users.any? { |u| u.id == user.id  }
  end

  # --- Private methods ---

  private

  def set_membership
    user = User.find_by(id: self.created_by)
    user.present? ? self.users << user : false
  end

end
