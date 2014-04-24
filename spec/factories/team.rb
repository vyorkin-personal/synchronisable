FactoryGirl.define do
  factory :team do
    name { generate :string }

    trait :with_stadium do
      association :stadium
    end

    trait :with_players do
      after(:build) do |object, evaluator|
        create_list(:player, 11, :team => object)
      end
    end
  end
end

