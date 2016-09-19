class AddCanvasToAreas < ActiveRecord::Migration[5.0]
  def change
    add_reference :areas, :canvas, foreign_key: true
  end
end
