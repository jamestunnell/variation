module Variation
class ConstantFunction
  def self.from_value value
    ->(x){ value }
  end
end
end