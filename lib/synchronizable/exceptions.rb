module Synchronizable
  # Error is thrown when remote id isn't supplied
  # with remote attibutes hash.
  class MissedRemoteIdError < StandardError; end
  # Error is thrown when required associations isn't supplied
  # with remote attributes hash.
  class MissedAssociationsError < StandardError; end
end
