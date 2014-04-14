class Deer < ActiveRecord::Base
  synchronizable

  scope :over_21, -> { where('age > 21') }
  scope :with_name, ->(name) { where(:name => name) }
end
