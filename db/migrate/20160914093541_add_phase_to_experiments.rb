class AddPhaseToExperiments < ActiveRecord::Migration[5.0]
  def change
    add_reference :experiments, :phase, foreign_key: true
  end
end
