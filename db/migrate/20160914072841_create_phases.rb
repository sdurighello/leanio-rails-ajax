class CreatePhases < ActiveRecord::Migration[5.0]
  def change
    create_table :phases do |t|
      t.date :start_date
      t.date :end_date
      t.integer :sequence
      t.integer :number_of_sprints
      t.integer :sprint_length
      t.boolean :completed

      t.timestamps
    end
  end
end
