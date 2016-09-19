class AddProjectToHypotheses < ActiveRecord::Migration[5.0]
  def change
    add_reference :hypotheses, :project, foreign_key: true
  end
end
