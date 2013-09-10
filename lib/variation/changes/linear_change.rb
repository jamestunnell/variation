module Variation
class LinearChange
  attr_reader :end_value, :length

  # Pass :length and :end_value by Hash. Length must be > 0.
  def initialize hashed_args
    length = hashed_args[:length]
    raise LengthNotPositiveError if length <= 0
    @length = length
    @end_value = hashed_args[:end_value]
  end

  def transition_function start_point
    end_point = [start_point[0] + length, end_value]
    LinearFunction.from_points start_point, end_point
  end
end
end
