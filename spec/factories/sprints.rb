FactoryGirl.define do
   factory :sprint do
      start_date { Date.today + rand(10000) }
      end_date { Date.today + rand(10000) }
      completed false
      things_done { Faker::Lorem.paragraph }
      things_learned { Faker::Lorem.paragraph }
      stories_estimated {rand(5..20)}
      stories_completed {rand(5..20)}
      points_estimated {rand(50..200)}
      points_completed {rand(50..200)}
      happiness { (Sprint::HAPPINESS).index((Sprint::HAPPINESS).sample) }
      impediments { Faker::Lorem.paragraph }
      association :phase
   end
end
