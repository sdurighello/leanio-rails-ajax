class CreateSprints < ActiveRecord::Migration[5.0]
  def change
    create_table :sprints do |t|
      t.date :start_date
      t.date :end_date
      t.boolean :completed
      t.text :things_done
      t.text :things_learned
      t.integer :stories_estimated
      t.integer :stories_completed
      t.integer :points_estimated
      t.integer :points_completed
      t.integer :happiness
      t.text :impediments

      t.timestamps
    end
  end
end
