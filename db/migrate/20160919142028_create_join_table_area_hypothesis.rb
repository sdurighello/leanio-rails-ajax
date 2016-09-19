class CreateJoinTableAreaHypothesis < ActiveRecord::Migration[5.0]
  def change
    create_join_table :areas, :hypotheses do |t|
      # t.index [:area_id, :hypothesis_id]
      # t.index [:hypothesis_id, :area_id]
    end
  end
end
