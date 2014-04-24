FactoryGirl.define do
  factory :stadium do
    name     { generate :string  }
    capacity { generate :integer }
  end
end

