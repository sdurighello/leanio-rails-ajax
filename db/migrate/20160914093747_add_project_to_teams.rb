class AddProjectToTeams < ActiveRecord::Migration[5.0]
  def change
    add_reference :teams, :project, foreign_key: true
  end
end
