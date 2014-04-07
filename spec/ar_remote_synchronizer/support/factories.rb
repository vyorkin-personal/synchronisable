FactoryGirl.define do
  factory :deer do
    name    { generate :string  }
    age     { generate :integer }
    weight  { generate :integer }
  end
end
