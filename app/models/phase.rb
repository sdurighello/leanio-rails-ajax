class Phase < ApplicationRecord
  belongs_to :project
  has_many :experiments, dependent: :destroy
  has_many :sprints, dependent: :destroy

  before_save :set_sprints # watch out! when you do update the phase_id exist, in create it doesn't! thank god for the .build()

  def name
    Project::PHASES[self.sequence]
  end

  protected

  def set_sprints

    start_date_valid = self.start_date.present?
    number_of_sprints_valid = self.number_of_sprints.present? && self.number_of_sprints > 0
    sprint_length_valid = self.sprint_length.present? && self.sprint_length > 0

    if start_date_valid && number_of_sprints_valid && sprint_length_valid

      end_date = get_end_date(self.start_date, self.number_of_sprints, self.sprint_length)
      self.end_date = end_date

      phase_weeks = get_phase_weeks(self.start_date, end_date, self.sprint_length)

      change_sprint_dates(self.sprints, phase_weeks) if self.sprints.present? && !self.sprints.empty?

      add_or_remove_sprints(self, phase_weeks)

    end
  end

  def get_end_date(start_date, number_of_sprints, sprint_length) # returns the new end date
    duration = number_of_sprints * sprint_length
    start_date + duration.weeks - 1
  end

  def get_phase_weeks(start_date, end_date, sprint_length) # returns an array of arrays of weeks [start_day, end_day]
    days = (Date.parse("#{self.start_date}")..Date.parse("#{self.end_date}")).to_a
    days.each_slice(self.sprint_length * 7).to_a.map do |w|
      [w.first, w.last].map { |d| "#{d.year}-#{d.month}-#{d.day}" }
    end
  end

  def change_sprint_dates(sprints, phase_weeks) # changes and saves sprints, returns true if no error
    sprints.each_with_index do |s, i|
      s.start_date = phase_weeks[i][0]
      s.end_date = phase_weeks[i][1]
      s.save
      break if i + 1 == phase_weeks.length # don't allow to go beyond the new number_of_sprints
    end
  end

  def add_or_remove_sprints(phase, phase_weeks) # destroy() or .build() the sprints referenced by the phase
    sprints_diff = phase.number_of_sprints - phase.sprints.length
    if sprints_diff < 0 # destroy old ones
      sprints_diff.abs.times do |i|
        s = phase.sprints[(phase.sprints.length - 1) - i ]
        Sprint.destroy(s.id)
      end
    end
    if sprints_diff > 0 # add new ones
      sprints_diff.times do |i|
        j = phase.sprints.length # this length will increase by 1 at each iteration because you're adding to the array!
        phase.sprints.build(start_date: phase_weeks[j][0], end_date: phase_weeks[j][1])
      end
    end
  end

end
