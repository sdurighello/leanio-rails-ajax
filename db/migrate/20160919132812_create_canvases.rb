class CreateCanvases < ActiveRecord::Migration[5.0]
  def change
    create_table :canvases do |t|
      t.string :name
      t.text :description

      t.integer :customers_to_break_even
      t.decimal :payback_period
      t.decimal :gross_margin
      t.decimal :market_size

      t.integer :customer_pain_level
      t.integer :market_ease_of_reach
      t.integer :feasibility
      t.integer :riskiness

      t.timestamps
    end
  end
end
