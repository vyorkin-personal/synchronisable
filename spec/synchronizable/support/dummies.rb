class HasOptions
  include Synchronizable::DSL::Option

  option :foo
  option :bar, default: 1
  option :baz, default: -> {
    bar + 1
  }
end
