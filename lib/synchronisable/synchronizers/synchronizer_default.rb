require 'synchronisable/synchronizer'

module Synchronisable
  # Default synchronizer to be used when
  # model specific synchronizer is not defined.
  #
  # @api private
  class SynchronizerDefault < Synchronizer
  end
end
