class Project < ApplicationRecord
  has_many :canvases, dependent: :destroy
  has_many :phases, inverse_of: :project, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :hypotheses, dependent: :destroy
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :phases, allow_destroy: true, reject_if: :all_blank

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

  def self.set_current_phase(project_id, phase_id)
    project = Project.find(project_id)
    project.current_phase_id = phase_id
    project.save!
  end

  # --- Instance methdos

  def current_phase
    Phase.find(self.current_phase_id)
  end

  def is_member?(user)
    return true if user.id == self.created_by
    self.users.any? { |u| u.id == user.id  }
  end

  def creator
    User.find_by(id: self.created_by)
  end

  def add_user(user_id, current_user_id)
    if (current_user_id == self.created_by) && (user_id != self.created_by) && (!self.users.any? { |u| u.id == user_id  })
      user = User.find_by(id: user_id)
      if user.present?
        self.users << user
        self.save!
      end
    end
  end

  def remove_user(user_id, current_user_id)
    # Only creators can remove but Users can remove themselves
    if ((current_user_id == self.created_by) || (user_id == current_user_id)) && (user_id != self.created_by) && (self.users.any? { |u| u.id == user_id  })
      user = User.find_by(id: user_id)
      if user.present?
        self.users.delete(user) # this doesn't destroy the user object but just the association
        self.save!
      end
    end
  end

  def update_active_status(current_user_id)
    if self.created_by == current_user_id
      self.active ? self.active = false : self.active = true
      self.save!
    end
  end

  # --- Private methods ---

  private

end
