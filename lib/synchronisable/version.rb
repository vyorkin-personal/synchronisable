module Synchronisable
  module VERSION
    MAJOR = 1
    MINOR = 2
    PATCH = 8
    SUFFIX = ''

    NUMBER = [MAJOR, MINOR, PATCH].compact.join('.')
    STRING =  "#{NUMBER}#{SUFFIX}"
  end
end
