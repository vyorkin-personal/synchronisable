class TeamGroupStatistic < ActiveRecord::Base
  belongs_to :team
  validates :team, presence: true

  synchronisable
end
