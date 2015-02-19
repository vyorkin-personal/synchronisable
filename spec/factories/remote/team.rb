FactoryGirl.define do
  factory :remote_team, class: Hash do
    maet_id { generate :team_id }

    eman    { generate :name }
    yrtnuoc { generate :string }
    ytic    { generate :string }

    ignored_1 { generate :string }
    ignored_2 { generate :timestamp }

    initialize_with { attributes }

    trait :with_players do
      after(:build) do |object, evaluator|
        players = build_list(:remote_player, 4, team: object[:maet_id])
        object[:player_ids] = players.map { |h| h[:player_id] }
      end
    end
  end
end
