require 'pry-byebug'

class BreakConventionTeamSynchronizer
  include Synchronizable::Synchronizer

  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )

  except :ignored_1, :ignored_2
end
