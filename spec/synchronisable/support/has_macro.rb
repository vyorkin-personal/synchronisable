class HasMacro
  include Synchronisable::DSL::Macro

  attribute :bar, default: 1
  attribute :foo
  attribute :baz, default: -> { bar + 1 }
  attribute :carefull, default: -> { raise NotImplementedError }
  attribute :xyz, converter: ->(x) { x.to_s }
  attribute :arr

  method :sqr
end
