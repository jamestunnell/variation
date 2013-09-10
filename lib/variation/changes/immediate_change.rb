module Variation
class ImmediateChange
  attr_reader :end_value, :length

  # Pass :end_value by Hash.
  def initialize hashed_args
    @length = 0
    @end_value = hashed_args[:end_value]
  end

  def transition_function start_point
    ConstantFunction.from_value end_value
  end
end
end
