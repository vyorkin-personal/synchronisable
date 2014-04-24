FactoryGirl.define do
  factory :match_player do
    association :player
    association :match

    formation_index { rand(10) + 1 }
    ref_type        { MatchPlayer::REF_TYPES.sample }
  end
end
