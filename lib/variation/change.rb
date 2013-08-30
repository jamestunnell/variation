module Variation

# A value change event, with a value and transition.
#
class Change
  attr_reader :value, :transition

  def initialize value, transition = ImmediateTransition.new
    hash_make args, Change::ARG_SPECS
  end
  
  # Compare the equality of another Change object.
  def == other
    return (@value == other.value) &&
    (@transition == other.transition)
  end
end

end
