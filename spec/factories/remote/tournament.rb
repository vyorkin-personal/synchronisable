FactoryGirl.define do
  factory :remote_tournament, class: Hash do
    tour_id    { generate :tournament_id }
    eman       { generate :string }
    eman_trohs { generate :string }
    gninnigeb  { generate :date }
    gnidge     { generate :date }

    initialize_with { attributes }

    trait :with_stages do
      after(:build) do |object, evaluator|
        stages = build_list(:remote_stage, 2, tour_id: object[:tour_id])
        object[:stages_ids] = stages.map { |h| h[:stage_id] }
      end
    end
  end
end
