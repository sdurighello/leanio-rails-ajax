FactoryGirl.define do
   factory :hypothesis do
      name { Faker::Company.catch_phrase }
      description { Faker::Lorem.paragraph }
      area_identifier { Canvas::AREAS.sample }
      association :project
   end
end
