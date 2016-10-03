class Project < ApplicationRecord
  has_many :canvases, dependent: :destroy
  has_many :phases, inverse_of: :project, dependent: :destroy
  has_many :hypotheses, dependent: :destroy
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :phases, allow_destroy: true, reject_if: :all_blank

  # --- Constants

  PHASES = ['Problem/Solution Fit', 'Product/Market Fit', 'Scale']

  def self.get_list_of_phases
    list_of_phases = []
    PHASES.each_with_index do |phase, index|
      list_of_phases << [phase, index]
    end
    list_of_phases
  end

  # --- Instance methdos

  def set_current_phase(phase_id)
    current_phase = Phase.find_by(id: phase_id)
    self.phases.each do |p|
      p.completed = true if p.sequence < current_phase.sequence
      p.completed = false if p.sequence >= current_phase.sequence
    end
    self.current_phase_id = phase_id
    self.save!
  end

  def current_phase
    begin
      Phase.find(self.current_phase_id)
    rescue
      self.errors.add :base, 'Current phase id is not valid'
      return false
    end
  end

  def is_member?(user)
    return true if user.id == self.created_by
    self.users.any? { |u| u.id == user.id  }
  end

  def creator
    begin
      User.find_by(id: self.created_by)
    rescue
      self.errors.add :base, 'Creator has invalid id'
      return false
    end
  end

  def add_user(user_id, current_user_id)
    if (current_user_id == self.created_by) && (!self.users.any? { |u| u.id == user_id  })
      user = User.find_by(id: user_id)
      if user.present?
        self.users << user
        self.save!
      end
    end
  end

  def remove_user(user_id, current_user_id)
    # Only creators can remove but Users can remove themselves
    if ((current_user_id == self.created_by) || (user_id == current_user_id)) && (self.users.any? { |u| u.id == user_id  })
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
