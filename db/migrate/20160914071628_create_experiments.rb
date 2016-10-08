class CreateExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :experiments do |t|
      t.string :type

      t.string :name
      t.text :description
      t.boolean :completed
      t.string :status

      t.integer :interviews_planned
      t.integer :interviews_done
      t.integer :early_adopters_planned
      t.integer :early_adopters_converted

      # problem experiment
      t.text :today_solution
      # solution experiment
      t.decimal :price_proposed
      t.integer :price_acceptance
      t.decimal :price_revised
      # product experiment
      t.integer :sean_ellis_test

      t.timestamps
    end
  end
end
