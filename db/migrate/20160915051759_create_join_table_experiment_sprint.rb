class CreateJoinTableExperimentSprint < ActiveRecord::Migration[5.0]
  def change
    create_join_table :experiments, :sprints do |t|
      # t.index [:experiment_id, :sprint_id]
      # t.index [:sprint_id, :experiment_id]
    end
  end
end
