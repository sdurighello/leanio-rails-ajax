FactoryGirl.define do
  factory :canvas do
    name {Faker::Company.catch_phrase}
    description {Faker::Lorem.paragraphs}
    customers_to_break_even {rand(10..1000)}
    payback_period {rand(1.0..4.0)}
    gross_margin {rand(10000..100000)}
    market_size {rand(1000..10000)}
    customer_pain_level {rand(1..5)}
    market_ease_of_reach {rand(1..5)}
    feasibility {rand(1..5)}
    riskiness {rand(1..5)}
    association :project
  end
end
