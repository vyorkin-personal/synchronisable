FactoryGirl.define do
  factory :remote_match, class: Hash do
    match_id  { generate :match_id }
    home_team { generate :team_id }
    away_team { generate :team_id }

    gninnigeb { generate :timestamp }
    rehtaew   { %w(worm cold rainy).sample }

    ignored_1 { generate :string }
    ignored_2 { generate :timestamp }

    line_up_home ['player_0']
    line_up_away ['player_1']

    substitutes_home ['player_2']
    substitutes_away ['player_3']

    initialize_with { attributes }
  end
end
