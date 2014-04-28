class HasOptions
  include Synchronizable::DSL::Options

  option :bar, default: 1
  option :foo
  option :baz, default: -> { bar + 1 }
  option :carefull, default: -> { raise NotImplementedError }
  option :xyz, converter: ->(x) { x.to_s }
  option :arr
end
