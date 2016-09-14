class AddProjectToPhases < ActiveRecord::Migration[5.0]
  def change
    add_reference :phases, :project, foreign_key: true
  end
end
