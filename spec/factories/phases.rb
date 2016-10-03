FactoryGirl.define do
  factory :phase do
    start_date { Date.today + rand(10000) }
    end_date { Date.today + rand(10000) }
    sequence 0
    number_of_sprints { rand(1..4) }
    sprint_length { rand(1..4) }
    completed false
    association :project
  end
end

# { Project::PHASES.index(Project::PHASES.sample) }
