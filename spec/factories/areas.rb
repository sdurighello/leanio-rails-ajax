FactoryGirl.define do
   factory :area do
      name (Canvas::AREAS).sample
      description Faker::Lorem.paragraph
      area_identifier (Canvas::AREAS).sample
      association :canvas
   end
end
