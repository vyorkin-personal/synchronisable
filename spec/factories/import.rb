FactoryGirl.define do
  factory :import, class: Synchronizable::Import do
    remote_id { generate :integer }
  end
end
