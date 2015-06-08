module Synchronisable
  # Gem version builder module
  module VERSION
    MAJOR = 1
    MINOR = 3
    PATCH = 0
    SUFFIX = ''

    NUMBER = [MAJOR, MINOR, PATCH].compact.join('.')
    STRING =  "#{NUMBER}#{SUFFIX}"
  end
end
