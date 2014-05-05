FactoryGirl.define :remote_match_player, class: Hash do
  match     { |n| "match_#{n}"  }
  player    { |n| "player_#{n}" }
  ref       { MatchPlayer.REF_TYPES.sample }

  formation generate :integer
end
