FactoryGirl.define do
  factory :remote_stage, class: Hash do
    stage_id  { generate :stage_id }
    tour_id   { generate :tournament_id }

    eman      { generate :string }
    rebmun    { generate :integer }
    gninnigeb { generate :timestamp }
    gnidge    { generate :date }

    ignored_1 { generate :date }
    ignored_2 { generate :timestamp }

    initialize_with { attributes }

    trait :with_matches do
      after(:build) do
        match = build(:remote_match,
          :home_team => 'team_0',
          :away_team => 'team_1'
        )
        object[:matches_ids] = [match[:match_id]]
      end
    end
  end
end
