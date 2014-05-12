FactoryGirl.define do
  factory :remote_tournament, class: Hash do
    tour_id    { generate :tournament_id }
    eman       { generate :string }
    eman_trohs { generate :string }
    gninnigeb  { generate :date }
    gnidge     { generate :date }

    initialize_with { attributes }
  end
end
