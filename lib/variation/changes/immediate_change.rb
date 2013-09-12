module Variation
class ImmediateChange < Change
  # Pass :end_value by hash.
  def initialize hashed_args
    super(hashed_args.merge(:length => 0))
  end

  def transition_function start_point
    ConstantFunction.from_value end_value
  end
end
end
