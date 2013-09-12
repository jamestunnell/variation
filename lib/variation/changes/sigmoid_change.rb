module Variation
class SigmoidChange < Change
  # Pass :length and :end_value by hash. Length must be > 0.
  def initialize hashed_args
    super(hashed_args)
    @abruptness = hashed_args[:abruptness] || 0.5
  end

  def transition_function start_point
    end_point = [start_point[0] + length, end_value]
    SigmoidFunction.from_points start_point, end_point, @abruptness
  end
end
end
