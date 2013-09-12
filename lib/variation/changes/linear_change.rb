module Variation
class LinearChange < Change
  # Pass :length and :end_value by hash. Length must be > 0.
  def initialize hashed_args
    super(hashed_args)
  end

  def transition_function start_point
    end_point = [start_point[0] + length, end_value]
    LinearFunction.from_points start_point, end_point
  end
end
end
