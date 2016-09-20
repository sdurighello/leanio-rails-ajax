class Hypothesis < ApplicationRecord
  belongs_to :project
  has_many :results, dependent: :destroy
  has_many :experiments, through: :results # TODO add 'dependent: :destroy, :nullify' to delete result if hypothesis is deleted but experiement stays and ref in experiment is set to null
  has_and_belongs_to_many :areas

  # To be used in grouped select as grouped_options_for_select
  def self.for_grouped_select
    select_hash = {}
    Canvas::AREAS.each do |area|
      select_hash[area] = []
    end
    Hypothesis.all.each do |h|
      select_hash[h.area_identifier] << [h.name, h.id]
    end
    select_hash
  end


end
