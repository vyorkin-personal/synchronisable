FactoryGirl.define do
  factory :remote_team_group_statistic, class: Hash do
    id { generate :team_id }
    team_id { id }

    games_played { generate :integer }
    games_won { generate :integer }
    games_lost { generate :integer }
    games_draw { generate :integer }

    initialize_with { attributes }
  end
end
