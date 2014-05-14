class MatchPlayer < ActiveRecord::Base
  REF_TYPES = [
    REF_TYPE_LINE_UP_HOME     = 'line_up_home',
    REF_TYPE_LINE_UP_AWAY     = 'line_up_away',
    REF_TYPE_SUBSTITUTES_HOME = 'substitutes_home',
    REF_TYPE_SUBSTITUTES_AWAY = 'substitutes_away'
  ]

  belongs_to :match
  belongs_to :player

  validates :match, :player, presence: true

  synchronisable
end
