FactoryGirl.define do
   factory :result do
     level { (Result::LEVELS).index((Result::LEVELS).sample) }
     comment { Faker::Lorem.paragraph }
     association :experiment
     association :hypothesis
   end
end
