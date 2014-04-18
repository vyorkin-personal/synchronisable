require 'pry-byebug'
class HasOptions
  include Synchronizable::DSL::Option

  option :bar, default: 1
  option :foo
  option :baz, default: -> { bar + 1 }
  option :xyz, converter: ->(x) { x.to_s }
end
