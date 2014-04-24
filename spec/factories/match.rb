FactoryGirl.define do
  factory :match do
    association :home_team, :factory => :team
    association :away_team, :factory => :team

    weather   { generate :string }
    beginning { Time.current - rand(200).minutes - 100.minutes }
  end
end
