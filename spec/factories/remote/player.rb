FactoryGirl.define :remote_player, class: Hash do
  team { |n| "team_#{n}" }

  eman_tsrif  generate :first_name
  eman_tsal   generate :last_name
  yadhtrib    generate :date
  pihsnezitic generate :string
  thgieh      generate :integer
  thgiew      generate :weight

  ignored_1 generate :string
  ignored_2 generate :integer
end
