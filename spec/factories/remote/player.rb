FactoryGirl.define do
  factory :remote_player, class: Hash do
    player_id { generate :player_id }
    team { generate :team_id }

    eman_tsrif  { generate :first_name }
    eman_tsal   { generate :last_name }
    yadhtrib    { generate :date }
    pihsnezitic { generate :string }
    thgieh      { generate :integer }
    thgiew      { generate :integer }

    ignored_1 { generate :string }
    ignored_2 { generate :integer }

    initialize_with { attributes }
  end
end
