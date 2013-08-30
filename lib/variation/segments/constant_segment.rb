module Variation

class ConstantSegment < Segment
  def initialize(value, width)
    super(width, ->(x){value})
  end
end

end
