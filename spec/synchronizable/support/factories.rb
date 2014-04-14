FactoryGirl.define do
  factory :deer do
    name    { generate :string  }
    age     { generate :integer }
    weight  { generate :integer }
  end

  factory :import, class: Synchronizable::Import do
    remote_id { generate :integer }

    trait :with_deer do
      association :synchronizable, factory: :deer
    end
  end
end
