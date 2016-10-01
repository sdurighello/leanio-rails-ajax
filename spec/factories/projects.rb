FactoryGirl.define do
   factory :project do
     name { Faker::Commerce.product_name }
     description { Faker::Lorem.paragraph }
     active true
   end
end
