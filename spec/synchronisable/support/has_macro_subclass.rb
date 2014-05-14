require_relative 'has_macro'

class HasMacroSubclass < HasMacro
  attribute :carefull, default: 0

  sqr do |x|
    x * x
  end
end
