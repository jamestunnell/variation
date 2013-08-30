module Variation

class Segment

  attr_reader :width

  def initialize width, function
  	raise DurationNotPositiveError if width <= 0
    @width = width
    @function = function
  end

  def at x
    raise OutsideOfDomainError unless x.between?(0,@width)
    @function.call(x)
  end
end

end