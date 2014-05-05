FactoryGirl.define :remote_team, class: Hash do
  maet_id { |n| "team_#{n}" }

  eman    generate :name
  yrtnuoc generate :string
  ytic    generate :string

  ignored_1 generate :string
  ignored_2 generate :timestamp

  # TODO: Somehow add player ids?
end
