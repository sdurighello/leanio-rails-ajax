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

end
