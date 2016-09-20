class CreateExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :experiments do |t|
      t.string :name
      t.text :description
      t.boolean :completed
      t.integer :interviews_planned
      t.integer :interviews_done
      t.integer :early_adopters_planned
      t.integer :early_adopters_converted

      t.timestamps
    end
  end
end
