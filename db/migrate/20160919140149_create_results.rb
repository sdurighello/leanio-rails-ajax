class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.integer :level
      t.text :comment
      t.references :experiment, foreign_key: true
      t.references :hypothesis, foreign_key: true

      t.timestamps
    end
  end
end
