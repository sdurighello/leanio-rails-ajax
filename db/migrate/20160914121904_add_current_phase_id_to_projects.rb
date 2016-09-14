class AddCurrentPhaseIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :current_phase_id, :integer
  end
end
