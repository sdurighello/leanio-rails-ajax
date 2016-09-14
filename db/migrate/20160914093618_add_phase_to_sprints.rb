class AddPhaseToSprints < ActiveRecord::Migration[5.0]
  def change
    add_reference :sprints, :phase, foreign_key: true
  end
end
