FactoryGirl.define do
   factory :experiment do
      name Faker::Company.catch_phrase
      description Faker::Lorem.paragraph
      completed false
      interviews_planned {rand(5..20)}
      interviews_done {rand(5..20)}
      early_adopters_planned {rand(50..200)}
      early_adopters_converted {rand(50..200)}
      association :phase
   end
end
