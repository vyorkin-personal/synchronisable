class Player < ActiveRecord::Base
  belongs_to :team

  synchronisable
end
