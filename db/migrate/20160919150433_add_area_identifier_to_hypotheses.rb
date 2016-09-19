class AddAreaIdentifierToHypotheses < ActiveRecord::Migration[5.0]
  def change
    add_column :hypotheses, :area_identifier, :string
  end
end
