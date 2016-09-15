class Phase < ApplicationRecord
  belongs_to :project
  has_many :experiments, dependent: :destroy
  has_many :sprints, dependent: :destroy

  after_create :set_sprints_new
  before_update :set_sprints_update

  def name
    Project::PHASES[self.sequence]
  end


  protected

  def set_sprints_new
    set_sprints(true)
  end

  def set_sprints_update
    set_sprints(false)
  end

  def set_sprints(new_resource)
    ex_phase = Phase.find_by_id(self.id)
    inputs_present = (self.start_date.present? && (self.number_of_sprints.present? && self.number_of_sprints > 0) && (self.sprint_length.present? && self.sprint_length > 0))
    inputs_changed = ((self.start_date != ex_phase.start_date) || (self.number_of_sprints != ex_phase.number_of_sprints) || (self.sprint_length != ex_phase.sprint_length))
    inputs_changed = true if new_resource
    if inputs_present && inputs_changed
      # Add calculated end date to the phase
      phase_duration = self.number_of_sprints * self.sprint_length
      self.end_date = self.start_date + phase_duration.weeks - 1
      self.save!
      # Get an array of arrays of [start_day, end_day] for each sprint
      days = (Date.parse("#{self.start_date}")..Date.parse("#{self.end_date}")).to_a
      weeks = days.each_slice(self.sprint_length * 7  ).to_a.map do |w|
        [w.first, w.last].map { |d| "#{d.year}-#{d.month}-#{d.day}" }
      end
      # Check existance of sprints
      if self.sprints.empty?
        # Create each separate sprint
        self.number_of_sprints.times do |i|
          new_sprint = Sprint.new(start_date: weeks[i][0], end_date: weeks[i][1], phase_id: self.id)
          new_sprint.save!
        end
      else
        # First change dates of all the existing sprints
        self.sprints.each_with_index do |s, i|
          s.start_date = weeks[i][0]
          s.end_date = weeks[i][1]
          s.save!
          break if i + 1 == weeks.length # don't allow to go beyond the new number_of_sprints
        end
        # Then append new ones or destroy from the end based on the diff
        sprints_diff = self.number_of_sprints - self.sprints.length
        if sprints_diff < 0 # destroy old ones
          sprints_diff.abs.times do |i|
            s = self.sprints[(self.sprints.length - 1) - i ]
            Sprint.destroy(s.id)
          end
        end
        if sprints_diff > 0 # add new ones
          sprints_diff.times do |i|
            j = self.sprints.length + i
            new_sprint = Sprint.new(start_date: weeks[j][0], end_date: weeks[j][1], phase_id: self.id)
            new_sprint.save!
          end
        end
      end

    else
      # do nothing
    end

  end

end
