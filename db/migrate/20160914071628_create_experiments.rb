class CreateExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :experiments do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.boolean :completed
      t.string :domain
      t.text :assumption
      t.text :method
      t.text :observation
      t.text :measure
      t.text :learned
      t.text :success_criteria
      t.text :action
      t.integer :interviews_planned
      t.integer :interviews_done
      t.integer :early_adopters_planned
      t.integer :early_adopters_converted

      t.timestamps
    end
  end
end
