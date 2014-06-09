class Stadium < ActiveRecord::Base
  # There is no synchronizer defined for this model,
  # so synchronization controller is gonna try
  # to use remote attributes as is to create a record

  synchronisable
end
