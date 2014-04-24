class Stadium < ActiveRecord::Base
  # There is no synchronizer defined for this model,
  # so synchronization worker is gonna try
  # to use remote attributes as is to create a record

  synchronizable
end
