FactoryGirl.define do
  factory :import, class: Synchronisable::Import do
    remote_id { generate :integer }
  end
end
