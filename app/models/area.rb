class Area < ApplicationRecord
  belongs_to :canvas
  has_and_belongs_to_many :hypotheses

  def add_hypothesis(hypothesis_id)
    begin
      hypothesis = Hypothesis.find(hypothesis_id)
      if self.hypotheses.include?(hypothesis)
        self.errors.add :base, 'This hypothesis has been already added'
        return false
      else
        self.hypotheses << hypothesis
        self.save!
      end
    rescue
      self.errors.add :base, 'Hypothesis not found'
      return false
    end
  end

  def remove_hypothesis(hypothesis_id)
    begin
      hypothesis = Hypothesis.find(hypothesis_id)
      if self.hypotheses.include?(hypothesis)
        self.hypotheses.delete(hypothesis)
        self.save!
      else
        self.errors.add :base, 'This hypothesis has been already added'
        return false
      end
    rescue
      self.errors.add :base, 'Hypothesis not found'
      return false
    end
  end

  def options_for_select_hypotheses
    # Get only hypotheses with that area_identifier that have not yet been associated with this area
    h_not_associated = Hypothesis.includes(:areas).where(area_identifier: self.area_identifier).where(areas: {id: nil})
    h_not_this_area = Hypothesis.includes(:areas).where(area_identifier: self.area_identifier).where.not(areas: {id: self.id})
    (h_not_associated + h_not_this_area).map { |h| [h.name, h.id] }
  end

end
