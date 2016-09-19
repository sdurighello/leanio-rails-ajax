class CreateAreas < ActiveRecord::Migration[5.0]
  def change
    create_table :areas do |t|
      t.string :name
      t.text :description
      t.string :area_identifier

      t.timestamps
    end
  end
end
