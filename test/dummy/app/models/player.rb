class Player < ActiveRecord::Base
  belongs_to :team

  synchronizable
end
