class Tournament < ActiveRecord::Base
  has_many :stages

  validates :name, :beginning, :ending, :presence => true

  synchronisable
end
