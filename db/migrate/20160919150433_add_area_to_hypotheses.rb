class AddAreaToHypotheses < ActiveRecord::Migration[5.0]
  def change
    add_column :hypotheses, :area, :string
  end
end
