class Canvas < ApplicationRecord
  belongs_to :project
  has_many :areas, dependent: :destroy
end
