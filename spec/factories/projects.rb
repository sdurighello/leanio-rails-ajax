FactoryGirl.define do
   factory :project do
     name { Faker::Commerce.product_name }
     description { Faker::Lorem.paragraph }
     active true
     current_phase_id { rand(1..10) }
     created_by { rand(1..10) }
   end
end
