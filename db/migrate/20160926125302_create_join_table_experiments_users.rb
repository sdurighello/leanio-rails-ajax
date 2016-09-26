class CreateJoinTableExperimentsUsers < ActiveRecord::Migration[5.0]
  def change
    create_join_table :experiments, :users do |t|
      # t.index [:experiment_id, :user_id]
      # t.index [:user_id, :experiment_id]
    end
  end
end
