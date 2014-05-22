require_relative 'has_macro_foo'

class HasMacroFooSubclass < HasMacroFoo
  attribute :carefull, default: 0

  sqr do |x|
    x * x
  end
end
