FactoryGirl.define do
  factory :player do
    first_name  { generate :string }
    last_name   { generate :string }
    birthday    { generate :date   }
    citizenship { generate :string }
    height      { rand }
    weight      { rand }
  end
end
