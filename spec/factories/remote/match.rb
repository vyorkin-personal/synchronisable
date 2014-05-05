FactoryGirl.define :remote_match, class: Hash do
  match_id  { |n| "match_#{n}" }
  away_team { |n| "team_#{n}"  }

  gninnigeb { generate :timestamp }
  rehtaew   { %w(worm cold rainy).sample }

  initialize_with { attributes }
end
